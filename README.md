WAS-Crawk-Preassembly
---------

This is the preassembly workflow for web archiving crawl objects. It is used the new  `robot-master`/`robot-controller`/`lyber-core` framework, which builds upon `resque` for job-management.

The workflow depends on 6 robots:
1) build_druid_tree:
2) metadata_extractor:
3) content_metadata_generator:
4) desc_metadata_generator:
5) technical_metadata_generator:
6) end_was_crawl_preassembly:
 

