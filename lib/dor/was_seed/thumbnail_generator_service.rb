# frozen_string_literal: true

require 'open3'
require 'net/http'

module Dor
  module WasSeed
    # TODO: why is this a class if it is full of class methods and has no constructor?
    class ThumbnailGeneratorService
      def self.capture_thumbnail(druid, workspace, seed_uri)
        screenshot_jpeg = "tmp/#{druid.delete_prefix('druid:')}.jpeg"
        resized_jpeg = "tmp/#{druid.delete_prefix('druid:')}_thumbsize.jpeg"
        begin
          # find the earliest capture we have for a given seed
          capture_timestamp = earliest_capture(seed_uri)

          # The `mp_` date suffix here instructs the wayback machine to either
          # give us a frameless replay, such as for PDFs, or redirect to the
          # framed version where necessary, like when displaying an HTML page.
          # This allows us to screenshot both PDFs and HTML pages in a uniform
          # way and get the desired result.
          wayback_uri = "#{Settings.was_seed.wayback_uri}/#{capture_timestamp}mp_/#{seed_uri}"
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
          _stdout_str, stderr_str, _status = Open3.capture3({ 'PUPPETEER_TMP_DIR' => tmp_dir }, "node scripts/screenshot.js '#{wayback_uri}' #{screenshot_jpeg} '#{Settings.chrome_path}'")
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

      # Queries the configured CDXJ API for the provided seed URI and returns
      # the the timestamp for the earliest 200 OK snapshot available.
      #
      # @param seed_uri [String] the seed URI to verify if it exists in the index
      # @return [String] a timestamp in the format YYYYMMDDHHMMSS
      # @raises [StandardError] if the seed_uri is not found in the CDX index
      def self.earliest_capture(seed_uri)
        cdx_index_url = URI(Settings.cdxj_indexer.url)
        cdx_index_url.query = URI.encode_www_form(url: seed_uri, output: 'json', filter: 'status:200')

        response = Net::HTTP.get_response(cdx_index_url)

        raise StandardError, "#{seed_uri} not found in cdxj index." if response.body.blank?

        # the response is json-lines so get and parse the first result and
        # return it timestamp
        snapshot = JSON.parse(response.body.split("\n")[0])
        snapshot['timestamp']
      end
    end
  end
end
