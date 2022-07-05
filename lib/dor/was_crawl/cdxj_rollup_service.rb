# frozen_string_literal: true

module Dor
  module WasCrawl
    class CdxjRollupService
      def initialize(level, index_dir)
        @level = level
        @index_dir = index_dir
      end

      # level is the index level from which to rollup
      def rollup
        src = @index_dir.join("level#{@level}.cdxj")
        dst = @index_dir.join("level#{@level + 1}.cdxj")

        # ensure only 1 rollup process at a time, and robots should use the
        # working.lock file to also to block while rollup work is being done
        Lockfile.new(@index_dir.join('working.lock').to_s) do
          raise "Missing #{src} file" unless src.exist?
          raise "Missing #{dst} file" unless dst.exist?

          if src.zero?
            puts "Nothing to do. No data in #{src}"
          else
            merge(src, dst)
          end
        end
      end

      def merge(src, dst)
        # we need to merge the 2 *already sorted* files into the new file, and
        # then zero out the current level of index
        cmd = "#{sort_env_vars} sort --merge --unique --output=#{dst}.new #{src} #{dst}"
        puts "Merging via #{cmd}"
        if system(cmd)
          FileUtils.mv("#{dst}.new", dst.to_s)
          FileUtils.rm(src.to_s)
          FileUtils.touch(src.to_s)
          puts "Rolled up level#{@level} into level#{@level + 1} CDXJ index"
        else
          puts "Failed to roll up level#{@level} into level#{@level + 1} CDXJ index. Cleaning up..."
          FileUtils.rm("#{dst}.new")
        end
      end

      def sort_env_vars
        # Ensure that the index is sorted by byte values
        # See https://specs.webrecorder.net/cdxj/0.1.0/#sorting
        "LC_ALL=C"
      end
    end
  end
end
