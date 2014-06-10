module Dor
  module WASCrawl
  
    class Utilities
    	def get_collection_id(druid_obj)
    		collections = druid_obj.collections
    		raise "#{druid_obj.id} doesn't belong to a collection" if collections.length == 0
    		
    		collection = collections[0]
    		return collection.id.replace('druid:','')
      end
      
      def get_crawl_id(druid_obj)
        return druid_obj.label
      end
 	  end
  end
 end
 