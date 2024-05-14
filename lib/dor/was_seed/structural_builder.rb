# frozen_string_literal: true

module Dor
  module WasSeed
    # Builds a Cocina representation of the structural metadata
    class StructuralBuilder
      # Generates structural metadata for a repository object.
      #
      # @param [Cocina::Models::DRO] cocina_model
      # @param [Assembly::ObjectFile] thumbnail the files to add to structural metadata
      def self.build(cocina_model:, thumbnail:)
        druid = cocina_model.externalIdentifier.delete_prefix('druid:') # remove druid prefix when creating IDs
        version = cocina_model.version
        object_access = cocina_model.access
        structural = {
          contains: [build_fileset(assembly_objectfile: thumbnail, druid:, version:, object_access:)]
        }

        cocina_model.structural.new(structural)
      end

      def self.administrative(file_attributes, object_access)
        {
          sdrPreserve: file_attributes[:preserve] == 'yes',
          publish: object_access.view == 'dark' ? false : file_attributes[:publish] == 'yes',
          shelve: object_access.view == 'dark' ? false : file_attributes[:shelve] == 'yes'
        }
      end
      private_class_method :administrative

      def self.build_fileset(assembly_objectfile:, druid:, version:, object_access:)
        contains = [build_file(assembly_objectfile:, version:, object_access:)]

        Cocina::Models::FileSet.new(
          externalIdentifier: "https://cocina.sul.stanford.edu/fileSet/#{druid}_1",
          label: 'Thumbnail',
          type: Cocina::Models::FileSetType['image'],
          version:,
          structural: {
            contains:
          }
        )
      end
      private_class_method :build_fileset

      def self.build_file(assembly_objectfile:, version:, object_access:)
        filename = 'thumbnail.jp2'

        exif = MiniExiftool.new assembly_objectfile.path
        width = exif.imagewidth
        height = exif.imageheight

        Cocina::Models::File.new(
          type: Cocina::Models::ObjectType.file,
          externalIdentifier: "https://cocina.sul.stanford.edu/file/#{SecureRandom.uuid}",
          label: filename,
          filename:,
          version:,
          administrative: administrative(assembly_objectfile.file_attributes, object_access),
          hasMessageDigests: [
            { type: 'sha1', digest: assembly_objectfile.sha1 },
            { type: 'md5', digest: assembly_objectfile.md5 }
          ],
          presentation: { height:, width: },
          size: assembly_objectfile.filesize,
          hasMimeType: 'image/jp2',
          access: { view: object_access.view, download: object_access.download }
        )
      end
      private_class_method :build_file
    end
  end
end
