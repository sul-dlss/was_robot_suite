module Dor
  module WASCrawl
    class Utilities
      def self.get_collection_id(druid_obj)
        collection = druid_obj.collections.first
        collection.id.sub('druid:', '')
      rescue => e
        raise "#{druid_obj.id} doesn't belong to a collection (#{e.message})"
      end

      def self.get_crawl_id(druid_obj)
        druid_obj.label
      end
    end
  end
end
