require 'open3'
require 'net/http'

module Dor
  module WasSeed
    class ThumbnailGeneratorService
      # because this date is earlier than any of the archived dates of the content,
      # this tells openwayback to provide the earliest capture date.
      DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE = '19900101120000'.freeze
      def self.capture_thumbnail(druid, workspace, seed_uri)
        screenshot_jpeg = "tmp/#{druid.delete_prefix('druid:')}.jpeg"
        begin
          indexed?(seed_uri)
          wayback_uri = "#{Settings.was_seed.wayback_uri}/#{DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE}/#{seed_uri}"
          screenshot(wayback_uri, screenshot_jpeg)
          resize_jpeg(screenshot_jpeg)
          thumbnail_file = "#{DruidTools::Druid.new(druid, workspace).content_dir}/thumbnail.jp2"
          Assembly::Image.new(screenshot_jpeg).create_jp2(output: thumbnail_file)
        rescue => e
          FileUtils.rm_rf(screenshot_jpeg)
          raise "Thumbnail for druid #{druid} and #{seed_uri} can't be generated.\n #{e.message}"
        ensure
          FileUtils.rm(screenshot_jpeg, force: true)
        end
      end

      def self.screenshot(wayback_uri, screenshot_jpeg)
        _stdout_str, stderr_str, _status = Open3.capture3("node scripts/screenshot.js #{wayback_uri} #{screenshot_jpeg} #{Settings.chrome_path}")
        raise stderr_str unless File.exist?(screenshot_jpeg)
      end

      def self.resize_jpeg(jpeg_file)
        image = MiniMagick::Image.open(jpeg_file)
        width = image.width
        height = image.height

        resize_dimension = if width > height
                             ' 400x '
                           else
                             ' x400 '
                           end
        image.resize resize_dimension
        image.write(jpeg_file)
      end

      # Queries the configured CDXJ API for the provided seed URI
      #
      # param seed_uri [String] the seed URI to verify if it exists in the index
      # raises [StandardError] if seed_uri is not found in the cdxj index
      def self.indexed?(seed_uri)
        cdx_index_url = "#{Settings.cdxj_indexer.url}#{seed_uri}"
        response = Net::HTTP.get_response(URI(cdx_index_url))
        return unless response.body.nil?

        raise StandardError, "#{seed_uri} not found in cdxj index."
      end
    end
  end
end
