# frozen_string_literal: true

# Helpers for building Cocina objects in specs
module CocinaHelpers
  # @return [Cocina::Models::DRO] a world-access object whose structure has a single jp2 thumbnail
  def with_jp2_structural(cocina_object, publish:)
    druid = cocina_object.externalIdentifier.delete_prefix('druid:')
    file = { type: Cocina::Models::ObjectType.file, externalIdentifier: "https://cocina.sul.stanford.edu/file/#{druid}_1",
             label: 'uploaded.jp2', filename: 'uploaded.jp2', version: 1, hasMimeType: 'image/jp2',
             access: { view: 'world', download: 'world' },
             administrative: { publish:, sdrPreserve: false, shelve: publish } }
    file_set = { type: Cocina::Models::FileSetType.image, externalIdentifier: "https://cocina.sul.stanford.edu/fileSet/#{druid}_1",
                 label: 'Thumbnail', version: 1, structural: { contains: [file] } }

    cocina_object.new(access: { view: 'world', download: 'world' },
                      structural: cocina_object.structural.to_h.merge(contains: [file_set]))
  end
end
