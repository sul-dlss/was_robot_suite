WAS-Crawk-Preassembly
---------

This is the preassembly workflow for web archiving crawl objects. It is used the new  `robot-master`/`robot-controller`/`lyber-core` framework, which builds upon `resque` for job-management.

The workflow depends on 6 robots:
# build_druid_tree:
# metadata_extractor:
# content_metadata_generator:
# desc_metadata_generator:
# technical_metadata_generator:
# end_was_crawl_preassembly:
 

## Configuration

Here are the files you will find in the `config` directory

`config/boot`
Loads supporting framework classes and configuration

`config/environments/bluepill_development.rb`
Configuration options for the `bluepill` process manager

`config/environments/workfows_development.rb`
You list workflow steps that will spawn workers, and optionally, how many workers per step

`config/workflows/demo_definition.xml`
An example of what the `robot-master` would use to determine the completion dependencies between steps

`config/workflows/demo_wf.xml`
How an actual instance of this demo workflow could be initialized in the `workflow-service`

