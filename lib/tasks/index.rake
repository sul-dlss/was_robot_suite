require 'lockfile'

require File.dirname(__FILE__) + '../../../config/boot' # for Dor::Config settings

# Location of the CDX index files
INDEX_DIR = Pathname.new(File.dirname(Settings.was_crawl_dissemination.main_cdx_file)).freeze

namespace :cdx do
  namespace :index do
    desc "Show all CDX indexes"
    task :show do
      system("ls -l #{INDEX_DIR}/level?.cdx")
    end

    namespace :admin do
      desc "Setup all CDX indexes (i.e., creates empty file if not present)"
      task :setup do
        (0..3).each do |i|
          fn = "#{INDEX_DIR}/level#{i}.cdx"
          FileUtils.touch(fn) unless File.exist?(fn)
        end
        Rake::Task['cdx:index:show'].execute
      end

      desc "Migrate old index file into multi-level index files"
      task :migrate do
        srcfn = INDEX_DIR.join('index.cdx')
        dstfn = INDEX_DIR.join('level3.cdx')
        raise "Old index is not present: #{srcfn}" unless srcfn.exist?
        dstfn.delete if dstfn.zero?
        raise "Level3 index already exists: #{dstfn}" if dstfn.exist?
        srcfn.rename(dstfn)
        Rake::Task['cdx:index:admin:setup'].execute
      end

      namespace :lockfile do
        desc "Show lockfile"
        task :show do
          system("ls -l #{INDEX_DIR.join('working.lock')}")
        end

        desc "Remove a stale lockfile"
        task :remove do
          lockfile = INDEX_DIR.join('working.lock')
          lockfile.delete if lockfile.exist?
        end
      end
    end

    namespace :rollup do
      def merge(n, src, dst)
        # load required environment variables from configuration file
        unless Settings.was_crawl_dissemination.sort_env_vars.nil?
          Settings.was_crawl_dissemination.sort_env_vars.split.each do |statement|
            ENV[statement.split(/=/).first] = statement.split(/=/).last
          end
        end

        # we need to merge the 2 *already sorted* files into the new file, and
        # then zero out the current level of index
        oflags = '--buffer-size=128M' # merge optimization flags
        cmd = "sort --merge --unique #{oflags} --output=#{dst}.new #{src} #{dst}"
        puts "Merging via #{cmd}"
        if system(cmd)
          FileUtils.mv("#{dst}.new", dst.to_s)
          FileUtils.rm(src.to_s)
          FileUtils.touch(src.to_s)
          puts "Rolled up level#{n} into level#{n + 1} CDX index"
        else
          puts "Failed to roll up level#{n} into level#{n + 1} CDX index. Cleaning up..."
          FileUtils.rm("#{dst}.new")
        end
      end

      def rollup(n) # n is the log level from which to rollup
        src = INDEX_DIR.join("level#{n}.cdx")
        dst = INDEX_DIR.join("level#{n + 1}.cdx")

        # ensure only 1 rollup process at a time, and robots should use the
        # working.lock file to also to block while rollup work is being done
        Lockfile.new(INDEX_DIR.join('working.lock').to_s) do
          raise "Missing #{src} file" unless src.exist?
          raise "Missing #{dst} file" unless dst.exist?

          if src.zero?
            puts "Nothing to do. No data in #{src}"
          else
            merge(n, src, dst)
          end
        end
      end

      desc "Rollup Level0 (today) into Level1 (daily) CDX index"
      task :level1 do
        rollup(0)
      end

      desc "Rollup Level1 (daily) into Level2 (monthly) CDX index"
      task :level2 do
        rollup(1)
      end

      desc "Rollup Level2 (monthly) into Level3 (yearly) CDX index"
      task :level3 do
        rollup(2)
      end
    end
  end
end
