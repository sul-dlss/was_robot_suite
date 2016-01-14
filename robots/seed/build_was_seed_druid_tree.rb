require 'find'

module Robots
  module DorRepo
    module WasSeedPreassembly
      class BuildWasSeedDruidTree
        include LyberCore::Robot

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'build-was-seed-druid-tree')
        end

        def perform(druid)

          staging_path = Dor::Config.was_seed.staging_path
          workspace_path = Dor::Config.was_seed.workspace_path

          druid_tree_directory = DruidTools::Druid.new(druid, workspace_path)
          source_xml_file = staging_path + "#{druid}.xml"

          if File.file?(source_xml_file)
            FileUtils.cp source_xml_file, "#{druid_tree_directory.content_dir}/source.xml"
              LyberCore::Log.info "Moving source xml file between #{source_xml_file} to #{druid_tree_directory.content_dir}/source.xml"
          else
            fail "There is no source xml file at #{source_xml_file} for druid #{druid}."
          end

        end
      end
    end
  end
end
