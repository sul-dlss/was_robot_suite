# frozen_string_literal: true

require 'zip'

module Dor
  module WasCrawl
    # Extracts WARC files from a WACZ and delete
    class WarcExtractorService
      def self.extract(base_path, wacz_filename)
        new(base_path, wacz_filename).extract
      end

      def initialize(base_path, wacz_filename)
        @base_path = base_path
        @wacz_filename = wacz_filename
      end

      def extract
        # TODO: Raise a HB exception if no WARCs are extracted. This would have
        # caught this situation.
        if data_package_profile == 'multi-wacz-package'
          extract_multi_wacz_package
        else
          extract_data_package(wacz_filepath)
        end
      end

      private

      attr_reader :base_path, :wacz_filename

      def wacz_filepath
        File.join(base_path, wacz_filename)
      end

      def wacz_basename
        @wacz_basename ||= File.basename(wacz_filename, '.wacz')
      end

      def wacz_data_package
        Zip::File.open(wacz_filepath) do |wacz_file|
          @wacz_data_package ||= JSON.parse(wacz_file.glob('datapackage.json').first.get_input_stream.read)
        end
      end

      def data_package_profile
        @data_package_profile ||= wacz_data_package['profile']
      end

      def data_package_resources
        @data_package_resources ||= wacz_data_package['resources']
      end

      def extract_data_package(filepath)
        Zip::File.open(filepath) do |wacz_file|
          wacz_file.glob('archive/*.warc.gz').each do |warc_entry|
            filename = warc_entry.name.delete_prefix('archive/')
            # Skip screenshots and text files as we do not use or preserve them.
            next if filename.downcase.match?(/screenshot|text/)

            # Prefixing warc filename with parent WACZ filename to make unique.
            dest_filename = "#{wacz_basename}-#{filename}"
            warc_entry.extract(dest_filename, destination_directory: base_path)
          end
        end
        File.delete(filepath)
      end

      def extract_multi_wacz_package
        Zip::File.open(wacz_filepath) do |wacz_file|
          data_package_resources.each do |resource|
            wacz_file.glob(resource['path']).each do |wacz_entry|
              filename = File.join(base_path, Pathname.new(wacz_entry.name).basename)
              wacz_entry.extract(filename)
              extract_data_package(filename)
            end
          end
        end
        File.delete(wacz_filepath)
      end
    end
  end
end
