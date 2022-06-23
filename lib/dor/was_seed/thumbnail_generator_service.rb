require 'open3'
require 'net/http'

module Dor
  module WasSeed
    class ThumbnailGeneratorService
      # because this date is earlier than any of the archived dates of the content,
      # this tells openwayback to provide the earliest capture date.
      DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE = '19900101120000'.freeze
      def self.capture_thumbnail(druid, workspace, uri)
        thumbnail_file = "#{DruidTools::Druid.new(druid, workspace).content_dir}/thumbnail.jp2"
        wayback_uri    = "#{Settings.was_seed.wayback_uri}/#{DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE}/#{uri}"
        temporary_file = "tmp/#{druid[6, 14]}"
        jpeg_file = "#{temporary_file}.jpeg"
        begin
          indexed?(uri)
          capture(wayback_uri, jpeg_file)
        rescue => e
          File.delete(jpeg_file) if File.exist?(jpeg_file)
          raise "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{e.message}"
        end

        resize_temporary_image(jpeg_file)
        Assembly::Image.new(jpeg_file).create_jp2(output: "#{temporary_file}.jp2")
        FileUtils.rm jpeg_file
        FileUtils.mv "#{temporary_file}.jp2", thumbnail_file
      end

      def self.capture(wayback_uri, temporary_file)
        _stdout_str, stderr_str, _status = Open3.capture3("node scripts/screenshot.js #{wayback_uri} #{temporary_file} #{Settings.chrome_path}")
        raise stderr_str unless File.exist?(temporary_file)
      end

      def self.resize_temporary_image(temporary_image)
        image = MiniMagick::Image.open(temporary_image)
        width = image.width
        height = image.height

        resize_dimension = if width > height
                             ' 400x '
                           else
                             ' x400 '
                           end
        image.resize resize_dimension
        image.write(temporary_image)
      end

      # Queries the configured CDXJ API for the provided URI
      #
      # param uri [String] the uri to verify if it exists in the index
      # raises [StandardError] if the uri is not found in the cdxj index
      def self.indexed?(uri)
        cdx_index_url = "#{Settings.cdxj_indexer.url}#{uri}"
        response = Net::HTTP.get_response(URI(cdx_index_url))
        return unless response.body.nil?

        raise StandardError, "#{uri} not found in cdxj index."
      end
    end
  end
end
