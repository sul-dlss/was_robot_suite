# frozen_string_literal: true

require 'find'

module Robots
  module DorRepo
    module WasCrawlPreassembly
      class BuildWasCrawlDruidTree < Base
        def initialize
          super('wasCrawlPreassemblyWF', 'build-was-crawl-druid-tree')
        end

        def perform(druid)
          cocina_model = Dor::Services::Client.object(druid).find

          crawl_id = Dor::WasCrawl::Utilities.get_crawl_id(cocina_model)
          crawl_directory = File.join(Settings.was_crawl.source_path, crawl_id)
          staging_path = Settings.was_crawl.staging_path

          druid_tree_directory = DruidTools::Druid.new(druid, staging_path)
          LyberCore::Log.info "Copying files from #{crawl_directory}/. to #{druid_tree_directory.content_dir}"
          Find.find(crawl_directory).each do |single_file|
            next unless File.file?(single_file)

            FileUtils.cp_r single_file, druid_tree_directory.content_dir
          end

          # Deleting after all copied.
          FileUtils.rm_rf(crawl_directory)
        end
      end
    end
  end
end
