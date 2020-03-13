require 'nokogiri'
require 'phantomjs'
require 'assembly-image'
require 'mini_magick'

module Dor
  module WASSeed
    class ThumbnailGeneratorService
      # because this date is earlier than any of the archived dates of the content,
      # this tells openwayback to provide the earliest capture date.
      DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE = '19900101120000'.freeze
      def self.capture_thumbnail(druid, workspace, uri)
        thumbnail_file = "#{DruidTools::Druid.new(druid, workspace).content_dir}/thumbnail.jp2"
        wayback_uri    = "#{Settings.was_seed.wayback_uri}/#{DATE_TO_TRIGGER_EARLIEST_CAPTURE_DATE}/#{uri}"
        temporary_file = "tmp/#{druid[6, 14]}"
        result = ''
        begin
          result = capture(wayback_uri, temporary_file)
        rescue => e
          File.delete(temporary_file + '.jpeg') if File.exist?(temporary_file + '.jpeg')
          raise "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{e.message}"
        end

        if result.starts_with?('#FAIL#')
          File.delete(temporary_file + '.jpeg') if File.exist?(temporary_file + '.jpeg')
          fail "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{result}"
        else
          resize_temporary_image(temporary_file + '.jpeg')
          Assembly::Image.new(temporary_file + '.jpeg').create_jp2(output: temporary_file + '.jp2')
          FileUtils.rm temporary_file + '.jpeg'
          FileUtils.mv temporary_file + '.jp2', thumbnail_file
        end
      end

      def self.capture(wayback_uri, temporary_file)
        result = ''
        begin
          result = Phantomjs.run('scripts/rasterize.js', wayback_uri, temporary_file + '.jpeg')
        rescue StandardError => e
          result += "\nException in generating thumbnail. #{e.message}\n#{e.backtrace.inspect}"
        end
        result
      end

      def self.resize_temporary_image(temporary_image)
        image = MiniMagick::Image.open(temporary_image)
        width = image.width
        height = image.height

        if width > height
          resize_dimension = ' 400x '
        else
          resize_dimension = ' x400 '
        end
        image.resize resize_dimension
        image.write(temporary_image)
      end
    end
  end
end
