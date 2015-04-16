require 'nokogiri'
require 'phantomjs'
require 'assembly-image'
module Dor
  module WASSeed
  
    class ThumbnailGeneratorService

      def self.capture_thumbnail(druid, workspace, uri)
        thumbnail_file  = "#{DruidTools::Druid.new(druid,workspace).content_dir}/thumbnail.jp2"
        wayback_uri     = "#{Dor::Config.was_seed.wayback_uri}/19900101120000/#{uri}"
        temporary_file  = "tmp/#{druid[6,14]}"
        
        result = ""
        begin
          result = self.capture( wayback_uri, temporary_file)
        rescue => e
          File.delete(temporary_file+".jpeg") if File.exist?(temporary_file+".jpeg") 
          raise "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{e.message}"
        end
        
        if (result.length > 0 && result.starts_with?('#FAIL#')) then
          File.delete(temporary_file+".jpeg") if File.exist?(temporary_file+".jpeg") 
          raise "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{result}"
        else  
          Assembly::Image.new(temporary_file+'.jpeg').create_jp2(:output=>temporary_file+".jp2")
          FileUtils.rm temporary_file+'.jpeg'
          FileUtils.mv temporary_file+".jp2", thumbnail_file
        end
      end

      def self.capture(wayback_uri, temporary_file)
        result = ""
        begin
          result = Phantomjs.run("scripts/rasterize.js", wayback_uri, temporary_file+".jpeg")
        rescue Exception => e 
          result = result +"\nException in generating thumbnail. #{e.message}\n#{e.backtrace.inspect}"
        end
        return result
      end
    end
  end
end
