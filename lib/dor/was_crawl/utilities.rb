module Dor
  module WasCrawl
    class Utilities
      # @param [Cocina::Models::DRO] cocina_model
      def self.get_collection_id(cocina_model)
        collections = cocina_model.structural.isMemberOf
        raise "#{cocina_model.externalIdentifier} doesn't belong to a collection" if collections.empty?

        # NOTE: While an object *may* belong to multiple collections, this
        #       codebase assumes a crawl belongs to one collection, so operate
        #       only on the first collection returned
        collections.first.delete_prefix('druid:')
      end

      # @param [Cocina::Models::DRO] cocina_model
      def self.get_crawl_id(cocina_model)
        cocina_model.label
      end
    end
  end
end
