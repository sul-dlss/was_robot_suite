module Dor
  module WASCrawl

    class Utilities
      def self.get_collection_id(druid_obj)
        collections = druid_obj.collections
        raise "#{druid_obj.id} doesn't belong to a collection" if collections.length == 0

        collection = collections[0]
        collection.id.sub('druid:', '')
      end

      def self.get_crawl_id(druid_obj)
        druid_obj.label
      end
     end
  end
 end
