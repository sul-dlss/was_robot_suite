const puppeteer = require('puppeteer');

/*
/ Usage:
/  node scripts/screenshot.js url output chrome-path
/
*/
async function run() {
    const executable = process.argv[4] || '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
    const browser = await puppeteer.launch({ executablePath: executable, headless: true });
    try {
        const page = await browser.newPage();
        await page.setViewport({ width: 1200, height: 800 });
        await page.goto(process.argv[2]);
        await page.screenshot({ path: process.argv[3], fullPage: true, format: 'jpeg' });
    } catch (err) {
        console.error(err.message)
    } finally {
        await browser.close()
    }
}

run();
