# frozen_string_literal: true

require 'open3'
require 'net/http'

module Dor
  module WasSeed
    class ThumbnailGeneratorService
      # because this date is earlier than any of the archived dates of the content,
      # this tells the wayback machine to provide the earliest capture date.
      DATE_TO_TRIGGER_EARLIEST_CAPTURE = '19900101120000'
      def self.capture_thumbnail(druid, workspace, seed_uri)
        screenshot_jpeg = "tmp/#{druid.delete_prefix('druid:')}.jpeg"
        resized_jpeg = "tmp/#{druid.delete_prefix('druid:')}_thumbsize.jpeg"
        begin
          indexed?(seed_uri)
          wayback_uri = "#{Settings.was_seed.wayback_uri}/#{DATE_TO_TRIGGER_EARLIEST_CAPTURE}/#{seed_uri}"
          screenshot(wayback_uri, screenshot_jpeg)
          resize_jpeg(screenshot_jpeg, resized_jpeg)
          thumbnail_file = "#{DruidTools::Druid.new(druid, workspace).content_dir}/thumbnail.jp2"
          Assembly::Image.new(resized_jpeg).create_jp2(output: thumbnail_file)
        rescue => e
          raise "Thumbnail for druid #{druid} and #{seed_uri} can't be generated.\n #{e.message}"
        ensure
          FileUtils.rm_f(screenshot_jpeg)
          FileUtils.rm_f(resized_jpeg)
        end
      end

      def self.screenshot(wayback_uri, screenshot_jpeg)
        stderr_str = nil
        Dir.mktmpdir do |tmp_dir|
          _stdout_str, stderr_str, _status = Open3.capture3({ 'PUPPETEER_TMP_DIR' => tmp_dir }, "node scripts/screenshot.js #{wayback_uri} #{screenshot_jpeg} #{Settings.chrome_path}")
        end
        raise stderr_str unless File.exist?(screenshot_jpeg)
      end

      # resizes the passed jpeg image to a 400 px max
      def self.resize_jpeg(orig_jpeg_file, resized_jpeg_file)
        require 'vips'

        image = Vips::Image.new_from_file(orig_jpeg_file)
        thumbnail = image.resize(400.0 / [image.width, image.height].max)
        thumbnail.jpegsave(resized_jpeg_file) # we need to save it to a different file; cleanup is handled by caller
      end

      # Queries the configured CDXJ API for the provided seed URI
      #
      # param seed_uri [String] the seed URI to verify if it exists in the index
      # raises [StandardError] if seed_uri is not found in the cdxj index
      def self.indexed?(seed_uri)
        cdx_index_url = "#{Settings.cdxj_indexer.url}#{seed_uri}"
        response = Net::HTTP.get_response(URI(cdx_index_url))
        return unless response.body.blank? # body is empty string when it's missing.

        raise StandardError, "#{seed_uri} not found in cdxj index."
      end
    end
  end
end
