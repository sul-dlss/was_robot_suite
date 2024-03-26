# frozen_string_literal: true

module Dor
  module WasSeed
    # Builds a Cocina representation of the structural metadata
    class DescriptiveBuilder
      # Generates structural metadata for a repository object.
      #
      # @param [String] purl
      # @param [String] seed_uri
      # @param [String] collection_id
      def self.build(purl:, seed_uri:, collection_id:) # rubocop:disable Metrics/MethodLength
        Cocina::Models::Description.new(
          title: [
            {
              value: "Web Archive Seed for #{seed_uri}"
            }
          ],
          form: [
            {
              value: 'archived website',
              type: 'genre',
              source: {
                code: 'local'
              }
            },
            {
              value: 'text',
              type: 'resource type',
              source: {
                value: 'MODS resource types'
              }
            },
            {
              value: 'electronic',
              type: 'form',
              source: {
                code: 'marcform'
              }
            },
            {
              value: 'text/html',
              type: 'media type',
              source: {
                value: 'IANA media types'
              }
            },
            {
              value: 'born digital',
              type: 'digital origin',
              source: {
                value: 'MODS digital origin terms'
              }
            }
          ],
          note: [
            {
              value: seed_uri,
              displayLabel: 'Original site'
            }
          ],
          access: {
            url: [
              {
                value: "#{Settings.was_seed.wayback_uri}/*/#{seed_uri}",
                displayLabel: 'Archived website'
              }
            ]
          },
          adminMetadata: {
            contributor: [
              {
                name: [
                  {
                    code: 'CSt',
                    source: {
                      code: 'marcorg'
                    }
                  }
                ],
                type: 'organization',
                role: [
                  {
                    value: 'original cataloging agency'
                  }
                ]
              }
            ],
            language: [
              {
                code: 'eng',
                source: {
                  code: 'iso639-2b',
                  uri: 'http://id.loc.gov/vocabulary/iso639-2'
                },
                uri: 'http://id.loc.gov/vocabulary/iso639-2/eng'
              }
            ],
            note: [
              {
                value: "Transformed from record for #{seed_uri} used in the web archiving service and which is part of the collection (record ID #{collection_id}).",
                type: 'record origin'
              }
            ]
          },
          purl:
        )
      end
    end
  end
end
