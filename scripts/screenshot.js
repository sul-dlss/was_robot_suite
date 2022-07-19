const ejs = require('ejs');
const path = require('path');
const puppeteer = require('puppeteer');

/*
/ Usage:
/  node scripts/screenshot.js url output chrome-path
/
*/
async function run() {
  const executable = process.argv[4] || '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome';
  const browser = await puppeteer.launch(
    {
      executablePath: executable,
      headless: true,
      args: [
        '--disable-web-security',
        '--disable-features=IsolateOrigins',
        '--disable-site-isolation-trials'
      ]
    }
  );
  const uri = process.argv[2]
  const page = await browser.newPage();

  try {
    await page.setViewport({ width: 1200, height: 800 });
    await page.goto(uri, {
      timeout: 30000,
      waitUntil: 'networkidle2'
    });
    await page.screenshot({ path: process.argv[3], format: 'jpeg' });
  } catch (err) {
    // Puppeteer cannot screenshot PDFs in headless mode by itself, so get some help from EJS and PDF.js
    // HT: https://stackoverflow.com/a/70437748
    if (err.message.match('net::ERR_ABORTED') && uri.match(/pdf/i)) {
      try {
        await page.addScriptTag({path: './node_modules/pdfjs-dist/build/pdf.min.js'});
        await page.addScriptTag({path: './node_modules/pdfjs-dist/build/pdf.worker.min.js'});
        const html = await ejs.renderFile('./scripts/template.ejs', { data: { uri } });
        await page.setContent(html, {
          waitUntil: 'networkidle0',
          timeout: 30000
        });
        await page.screenshot({ path: process.argv[3], format: 'jpeg' });
      } catch (err) {
        console.error(err.message);
      }
    } else {
      console.error(err.message);
    }
  } finally {
    await browser.close()
  }
}

run();
