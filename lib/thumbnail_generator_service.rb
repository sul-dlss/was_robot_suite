require 'nokogiri'
require 'phantomjs'

module Dor
  module WASSeed
  
    class ThumbnailGenerator

      def self.capture_thumbnail(druid, workspace, uri)
        thumbnail_file  = "#{DruidTools::Druid.new(druid,workspace).content_dir}/thumbnail.jpeg"
        wayback_uri     = "#{Dor::Config.was_seed.wayback_uri}/19900101120000/#{uri}"
        temporary_file  = "tmp/#{druid[6,14]}.jpeg"
        
        result = ThumbnailGenerator.run_thumbnail_generator( wayback_uri, temporary_file)
        puts result
        if result.length == 0 then
          FileUtils.mv temporary_file, thumbnail_file
        else         
          if File.exist?(temporary_file) then File.delete(temporary_file) end
          raise "Thumbnail for druid #{druid} and #{uri} can't be generated.\n #{result}"
        end
        
      end
      
      def self.run_thumbnail_generator(wayback_uri, temporary_file)
        
        #To ensure the phantomJS is installed
        Phantomjs.path
        
        result = ""
        begin
          result = Phantomjs.run("scripts/rasterize.js", wayback_uri, temporary_file)
        rescue Exception => e  
          result = result +"\nException in generating thumbnail. #{e.message}\n#{e.backtrace.inspect}"
        end
        return result
      end
    end
  end
end
