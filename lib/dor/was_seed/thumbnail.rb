# frozen_string_literal: true

module Dor
  module WasSeed
    # A seed's thumbnail: the jp2 in the staging folder (staged by argo-b3 or generated there), or the existing published one.
    class Thumbnail
      # @param [String] druid
      # @param [Cocina::Models::DRO] cocina_model
      def initialize(druid:, cocina_model:)
        @staged_content = StagedContent.new(druid:)
        @cocina_model = cocina_model
      end

      def content_dir
        staged_content.content_dir
      end

      # @return [String, nil] the path of the jp2 in the staging folder, if there is one
      # @raise [RuntimeError] if there is more than one jp2
      def path
        return @path if defined?(@path)

        @path = staged_content.jp2_path
      end

      # No jp2 in the staging folder, but the seed already has a published (possibly uploaded) one.
      def keep_existing?
        path.nil? && published_jp2?
      end

      private

      attr_reader :staged_content, :cocina_model

      def published_jp2?
        cocina_model.structural.contains.flat_map { |file_set| file_set.structural.contains }
                    .any? { |file| file.hasMimeType == 'image/jp2' && file.administrative.publish }
      end
    end
  end
end
