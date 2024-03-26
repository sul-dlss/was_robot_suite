# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dor::WasSeed::StructuralBuilder do
  let(:test_input_dir) { File.join(__dir__, '../../../../fixtures/content_metadata') }
  let(:workspace) { 'spec/was_seed_preassembly/fixtures/workspace' }
  let(:path) { "#{workspace}/gh/123/gh/1234/gh123gh1234/content" }

  describe '.build' do
    subject(:result) { described_class.build(cocina_model:, thumbnail:) }

    let(:druid) { 'druid:nx288wh8889' }
    let(:cocina_model) { build(:dro, id: druid, type: object_type) }
    let(:file_attributes) { { publish: 'no', preserve: 'yes', shelve: 'no' } }

    before do
      FileUtils.mkdir_p(path)
      FileUtils.cp('spec/was_seed_preassembly/fixtures/thumbnail_files/thumbnail.jp2', path)

      allow(SecureRandom).to receive(:uuid).and_return(*1.upto(16).map(&:to_s))
    end

    context 'when providing file attributes' do
      let(:object_type) { Cocina::Models::ObjectType.webarchive_seed }

      let(:thumbnail) do
        Assembly::ObjectFile.new(File.join(path, 'thumbnail.jp2'), file_attributes: { publish: 'yes', preserve: 'no', shelve: 'yes' })
      end

      let(:expected) do
        { contains: [{ type: 'https://cocina.sul.stanford.edu/models/resources/image',
                       externalIdentifier: 'https://cocina.sul.stanford.edu/fileSet/nx288wh8889_1',
                       label: 'Thumbnail',
                       version: 1,
                       structural: { contains: [{ type: 'https://cocina.sul.stanford.edu/models/file',
                                                  externalIdentifier: 'https://cocina.sul.stanford.edu/file/1',
                                                  label: 'thumbnail.jp2',
                                                  filename: 'thumbnail.jp2',
                                                  version: 1,
                                                  presentation: {
                                                    height: 1215,
                                                    width: 1000
                                                  },
                                                  hasMimeType: 'image/jp2',
                                                  hasMessageDigests: [
                                                    {
                                                      type: 'sha1',
                                                      digest: 'c78e5e8e8ca02c6fffa9169b0e9e4df908675fdc'
                                                    },
                                                    {
                                                      type: 'md5',
                                                      digest: 'cecab42610cefd7f8ba80c8505a0f95f'
                                                    }
                                                  ],
                                                  access: { view: 'dark', download: 'none', controlledDigitalLending: false },
                                                  administrative: { publish: false, sdrPreserve: false, shelve: false } }] } }],
          hasMemberOrders: [],
          isMemberOf: [] }
      end

      it 'generates role attributes for structural metadata' do
        expect(result.to_h).to eq expected
      end
    end
  end
end
