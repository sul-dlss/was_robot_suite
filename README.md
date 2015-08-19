[![Build Status](https://travis-ci.org/sul-dlss/was-crawl-preassembly.svg?branch=master)](https://travis-ci.org/sul-dlss/was-crawl-preassembly) [![Coverage Status](https://coveralls.io/repos/sul-dlss/was-crawl-preassembly/badge.png)](https://coveralls.io/r/sul-dlss/was-crawl-preassembly) [![Dependency Status](https://gemnasium.com/sul-dlss/was-crawl-preassembly.svg)](https://gemnasium.com/sul-dlss/was-crawl-preassembly) 

was-crawl-preassembly
---------

This is the preassembly workflow for web archiving crawl objects. It is used the new  `robot-master`/`robot-controller`/`lyber-core` framework, which builds upon `resque` for job-management.

The workflow depends on 6 robots:

1. `build-was-crawl-druid-tree`: this robot reads the crawl object content (ARCs or WARCs and logs) from directory defined by crawl object label, then it builds druid tree, and copy the content to the druid tree content directory.

2. `metadata_extractor`: this robot extracts the metadata from the (W)ARCs files using java jar file. The output is an xml includes metadata for the (W)ARCs and general information about the other files.

3. `content_metadata_generator`: this robot generates content metadata based on the xml created from `metadata_exrtactor` and `contentMetadata.xslt` template.

4. `desc_metadata_generator`: this robot generates desc metadata based on the xml created from `metadata_exrtactor` and `descMetadata.xslt` template.

5. `technical_metadata_generator`: this robot generates technical metadata based on the xml created from `metadata_exrtactor` and `techicalMetadata.xslt` template.

6. `end_was_crawl_preassembly`: this is the last step of the wasCrawlPreassemblyWF and it initiates the accesionWF.
 

