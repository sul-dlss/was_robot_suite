# frozen_string_literal: true

RSpec.describe Dor::WasSeed::DescriptiveBuilder do
  let(:fixtures) { 'spec/was_seed_preassembly/fixtures/' }

  describe '.build' do
    subject(:result) { described_class.build(purl:, seed_uri:, collection_id:) }

    let(:purl) { 'https://purl.stanford.edu/bc234fg5678' }
    let(:collection_id) { 'druid:mc744qd2082' }
    let(:seed_uri) { 'http://www.frontnational.com/?post_type=works' }

    it 'produces descriptive metadata' do # rubocop:disable RSpec/ExampleLength
      expect(result).to eq(Cocina::Models::Description.new(
                             {
                               title: [
                                 { value: 'Web Archive Seed for http://www.frontnational.com/?post_type=works' }
                               ],
                               form: [
                                 { value: 'archived website', type: 'genre', source: { code: 'local' } },
                                 { value: 'text', type: 'resource type', source: { value: 'MODS resource types' } },
                                 { value: 'electronic', type: 'form', source: { code: 'marcform' } },
                                 { value: 'text/html', type: 'media type', source: { value: 'IANA media types' } },
                                 { value: 'born digital', type: 'digital origin', source: { value: 'MODS digital origin terms' } }
                               ],
                               note: [{ value: 'http://www.frontnational.com/?post_type=works', displayLabel: 'Original site' }],
                               access: { url: [{ value: 'https://swap.stanford.edu/*/http://www.frontnational.com/?post_type=works', displayLabel: 'Archived website' }] },
                               adminMetadata: {
                                 contributor: [
                                   {
                                     name: [{ code: 'CSt', source: { code: 'marcorg' } }],
                                     type: 'organization',
                                     role: [{ value: 'original cataloging agency' }]
                                   }
                                 ],
                                 language: [
                                   {
                                     code: 'eng',
                                     source: { code: 'iso639-2b', uri: 'http://id.loc.gov/vocabulary/iso639-2' },
                                     uri: 'http://id.loc.gov/vocabulary/iso639-2/eng'
                                   }
                                 ],
                                 note: [
                                   {
                                     value: 'Transformed from record for http://www.frontnational.com/?post_type=works ' \
                                            'used in the web archiving service and which is part of the collection ' \
                                            '(record ID druid:mc744qd2082).',
                                     type: 'record origin'
                                   }
                                 ]
                               },
                               purl: 'https://purl.stanford.edu/bc234fg5678'
                             }
                           ))
    end
  end
end
