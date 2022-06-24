require 'zip'

module Dor
  module WasCrawl
    # Extracts WARC files from a WACZ and delete
    class WarcExtractorService
      def self.extract(collection_path, wacz_filename)
        new(collection_path, wacz_filename).extract
      end

      def initialize(collection_path, wacz_filename)
        @collection_path = collection_path
        @wacz_filename = wacz_filename
      end

      def extract
        Zip::File.open(wacz_filepath) do |wacz_file|
          wacz_file.glob('archive/*.warc.gz').each do |warc_entry|
            filename = warc_entry.name.delete_prefix('archive/')
            # Prefixing with WACZ filename to make unique.
            warc_entry.extract(File.join(collection_path, "#{wacz_basename}-#{filename}"))
          end
        end
        File.delete(wacz_filepath)
      end

      private

      attr_reader :collection_path, :wacz_filename

      def wacz_filepath
        File.join(collection_path, wacz_filename)
      end

      def wacz_basename
        @wacz_basename ||= File.basename(wacz_filename, '.wacz')
      end
    end
  end
end
