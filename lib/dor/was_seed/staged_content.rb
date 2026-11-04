# frozen_string_literal: true

module Dor
  module WasSeed
    # A seed's files in the assembly location, where argo-b3 stages them and wasSeedPreassemblyWF adds the thumbnail.
    # accessionWF then moves the folder to the workspace.
    class StagedContent
      attr_reader :content_dir

      def initialize(druid:, staging_path: Settings.was_seed.staging_path)
        @content_dir = DruidTools::Druid.new(druid, staging_path).content_dir(false)
      end

      def any?
        Dir.glob('**/*', base: content_dir).any? { |path| File.file?(File.join(content_dir, path)) }
      end

      # Only at the top level, since the jp2's filename in the structure has no folder.
      # @return [String, nil] the path of the jp2 thumbnail, if there is one
      # @raise [RuntimeError] if there is more than one jp2, since only one can be the published thumbnail
      def jp2_path
        jp2s = Dir.glob('*.jp2', base: content_dir).sort
        raise "Expected at most one jp2 in #{content_dir} but found #{jp2s.size}: #{jp2s.join(', ')}" if jp2s.size > 1

        jp2s.first&.then { |path| File.join(content_dir, path) }
      end
    end
  end
end
