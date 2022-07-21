# frozen_string_literal: true

require 'lockfile'

require "#{File.dirname(__FILE__)}../../../config/boot" # for Dor::Config settings

# Location of the CDXJ index files used by pywb
INDEX_DIR_CDXJ = Pathname.new(File.dirname(Settings.was_crawl_dissemination.main_cdxj_file)).freeze

namespace :cdxj do
  namespace :index do
    desc 'Show all CDXJ indexes'
    task :show do
      system("ls -l #{INDEX_DIR_CDXJ}/level?.cdxj")
    end

    namespace :admin do
      namespace :lockfile do
        desc 'Show lockfile'
        task :show do
          system("ls -l #{INDEX_DIR_CDXJ.join('working.lock')}")
        end

        desc 'Remove a stale lockfile'
        task :remove do
          lockfile = INDEX_DIR_CDXJ.join('working.lock')
          lockfile.delete if lockfile.exist?
        end
      end
    end

    namespace :rollup do
      desc 'Rollup Level0 (today) into Level1 (daily) CDX index'
      task :level1 do
        cdxj_rollup = Dor::WasCrawl::CdxjRollupService.new(0, INDEX_DIR_CDXJ)
        cdxj_rollup.rollup
      end

      desc 'Rollup Level1 (daily) into Level2 (monthly) CDX index'
      task :level2 do
        cdxj_rollup = Dor::WasCrawl::CdxjRollupService.new(1, INDEX_DIR_CDXJ)
        cdxj_rollup.rollup
      end

      desc 'Rollup Level2 (monthly) into Level3 (yearly) CDX index'
      task :level3 do
        cdxj_rollup = Dor::WasCrawl::CdxjRollupService.new(2, INDEX_DIR_CDXJ)
        cdxj_rollup.rollup
      end
    end

    namespace :cleanup do
      desc 'Cleans cdxj backups empty directories'
      task empty_directories: :environment do
        # Setting mindepth to 1 prevents the command from wiping out the root dir if empty
        `find #{Settings.cdxj_indexer.backup_directory} -mindepth 1 -not -path "*/\.*" -type d -empty -delete`
      end

      desc 'Clean cdxj backups'
      task indexes: :environment do
        `find #{Settings.cdxj_indexer.backup_directory} -mindepth 2 -type f -ctime +7 -delete`
      end
    end
  end
end
