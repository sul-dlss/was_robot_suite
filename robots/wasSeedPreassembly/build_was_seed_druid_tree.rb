require 'find'

module Robots
  module DorRepo
    module WasSeedPreassembly
      class BuildWasSeedDruidTree
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'build-was-seed-druid-tree')
        end

        def perform(druid)

          staging_path = Dor::Config.was_seed.staging_path
          workspace_path = Dor::Config.was_seed.workspace_path

          druid_tree_directory = DruidTools::Druid.new(druid, workspace_path)
          source_xml_file = staging_path + "#{druid}.xml"

          # Wait for dor-services-app to finish registering object, and firing off workflow
          # whereas was-registrar needs to wait for dor-services-app to finish to get the druid
          # for the source XML file. So, we wait here for up to 5 mins for this file to appear.
          (1..10).each do |i|
            break if File.file?(source_xml_file)
            LyberCore::Log.info "Waiting for source XML file: Try #{i}: #{source_xml_file}..."
            sleep(30)
          end

          fail "There is no source xml file at #{source_xml_file} for druid #{druid}." unless File.file?(source_xml_file)

          FileUtils.cp source_xml_file, "#{druid_tree_directory.content_dir}/source.xml"
            LyberCore::Log.info "Copying source xml file from #{source_xml_file} to #{druid_tree_directory.content_dir}/source.xml"
        end
      end
    end
  end
end
