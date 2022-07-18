[![CircleCI](https://circleci.com/gh/sul-dlss/was_robot_suite.svg?style=svg)](https://circleci.com/gh/sul-dlss/was_robot_suite)
[![Code Climate](https://codeclimate.com/github/sul-dlss/was_robot_suite/badges/gpa.svg)](https://codeclimate.com/github/sul-dlss/was_robot_suite)
[![Test Coverage](https://codeclimate.com/github/sul-dlss/was_robot_suite/badges/coverage.svg)](https://codeclimate.com/github/sul-dlss/was_robot_suite/coverage)

[![GitHub tagged version](https://badge.fury.io/gh/sul-dlss%2Fwas_robot_suite.svg)](https://badge.fury.io/gh/sul-dlss%2Fwas_robot_suite)

WAS_Robot_Suite
---------------

Robot code for accessioning and preservation of Web Archiving Service Seed and Crawl objects.

## General Robot Documentation

[Deprecated] Check the [Wiki](https://github.com/sul-dlss/robot-master/wiki) in the robot-master repo.

To run, use the `lyber-core` infrastructure, which uses `bundle exec controller boot`
to start all robots defined in `config/environments/robots_ENV.yml`.

## Deployment

Various dependencies, including `cdxj-indexer` which is installed by puppet via `pip3`, can be found in `config/settings.yml` and [shared_configs](https://github.com/sul-dlss/shared_configs) (was-robotsxxx branches)

## Prerequisites

See below.

# Workflows

See consul pages in Web Archival portal, esp Web Archiving Development Documentation

## wasCrawlPreassembly

Preassembly workflow for web archiving crawl objects (that include WARC or ARC files) to extract and create metadata.  It consists of these robots:

* `build-was-crawl-druid-tree`: this robot reads the crawl object content (ARCs or WARCs and logs) from directory defined by crawl object label, builds a druid tree, and copies the content to the druid tree content directory.
* `end_was_crawl_preassembly`: initiates the accessionWF (of common-accessioning).

## wasCrawlDissemination

Dissemination workflow for web archiving crawl objects.  It is kicked off by the last step in the common-accessioning end-accession step that reads the disseminationWF that is suitable for this object type based on APO. It consists of these robots:

* `warc-extractor`: extracts WARC files from WACZ files
* `cdxj-generator`: performs the basic indexing for the WARC/ARC files and generates CDXJ files (web archiving index files used by pywb). Generates 1 CDXJ file for each WARC file; the generated CDXJ files will be copied to `/web-archiving-stacks`.
* `cdxj-merge`: performs two main tasks:  1) Merges the individual CDXJ files that are generated in the previous step with the main index file (`/web-archiving-stacks/data/indexes/cdx/level0.cdxj`) 2) Sorts the new generated index file.

## wasSeedPreassembly

Preassembly workflow for web archiving seed objects.

It consists of 4 robots:

* `desc-metadata-generator`: generates the descMetadata in MODS format for the seed object.
* `thumbnail-generator`: captures a screenshot for the first memento using puppeteer and includes it as the main image for the object. This image will be used in Argo and SearchWorks's sul-embed.  If the robot fails to generate a thumbnail, it shows as an error in Argo.
* `content-metadata-generator`: generates contentMetadata.xml for the thumbnail by processing the contentMetadata.XSLT template against the available thumbnail.jp2.
* `end-was-seed-preassembly`: initiates the accessionWF (of common-accessioning) and opens/closes version for the old object.

## wasDissemination

Workflow to route web archiving objects to wasCrawlDisseminationWF based on content type. Note that the wasDisseminationWF itself is fired off by the accessionWF by using the administrative.disseminationWorkflow value in the APO. For example, if the APO has the following, it'll fire off wasDisseminationWF:

```
  "administrative": {
      "disseminationWorkflow": "wasDisseminationWF",
```

It consists of 1 robot:

* `start_special_dissemination`: sends objects with content type `webarchive-binary` to wasCrawlDisseminationWF.

## Index rollup
There is a scheduled task to roll up the `level0.cdxj` files into `level1` each night, plus additional rollups to `level2` and `level3`, monthly and yearly respectively.

# Prerequisites

## For thumbnail image creation

1. Kakadu Proprietary Software Binaries - for JP2 generation
2. libvips
3. Exiftool
4. Puppeteer
5. Google Chrome

### Kakadu

Download and install demonstration binaries from Kakadu:
http://kakadusoftware.com/downloads/

NOTE: If you have upgrade to El Capitan on OS X, you will need to donwload and re-install the latest version of Kakadu, due to changes made with SIP.  These changes moved the old executable binaries to an inaccessible location.

### Libvips

#### Mac

```bash
brew install libvips
```

### Exiftool

#### RHEL
Download latest version from: http://www.sno.phy.queensu.ca/~phil/exiftool

```bash
tar -xf Image-ExifTool-#.##.tar.gz
cd Image-ExifTool-#.##
perl Makefile.PL
make test
sudo make install
```

### Puppeteer

```bash
yarn install
```
