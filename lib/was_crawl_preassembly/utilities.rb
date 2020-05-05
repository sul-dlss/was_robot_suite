module Dor
  module WASCrawl
    class Utilities
      # @param [Cocina::Models::DRO] cocina_model
      def self.get_collection_id(cocina_model)
        collection = cocina_model.structural.isMemberOf
        raise "#{cocina_model.externalIdentifier} doesn't belong to a collection" unless collection

        collection.delete_prefix('druid:')
      end

      # @param [Cocina::Models::DRO] cocina_model
      def self.get_crawl_id(_cocina_model)
        druid_obj.label
      end
    end
  end
end
