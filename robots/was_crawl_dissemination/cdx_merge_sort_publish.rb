require 'lockfile'

module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxMergeSortPublish
        include LyberCore::Robot
        include Was::Robots::Base

        def initialize
          super('dor', 'wasCrawlDisseminationWF', 'cdx-merge-sort-publish')
        end

        # `perform` is the main entry point for the robot. This is where
        # all of the robot's work is done.
        #
        # @param [String] druid -- the Druid identifier for the object to process
        def perform(druid)
          cdx_working_directory = Settings.was_crawl_dissemination.cdx_working_directory
          cdx_backup_directory = Settings.was_crawl_dissemination.cdx_backup_directory
          cdx_merge_sort_publish = Dor::WASCrawl::CDXMergeSortPublishService.new( druid, cdx_working_directory, cdx_backup_directory)
          main_cdx_dir = File.dirname(Settings.was_crawl_dissemination.main_cdx_file)

          Lockfile.new("#{main_cdx_dir}/working.lock") do # synchornize writes with other processes
            unless Dir["#{cdx_working_directory}/#{druid}/*"].empty?
              cdx_merge_sort_publish.sort_druid_cdx
              cdx_merge_sort_publish.merge_with_main_index
              cdx_merge_sort_publish.publish
            end
            cdx_merge_sort_publish.clean
          end
        end
      end

    end
  end
end
