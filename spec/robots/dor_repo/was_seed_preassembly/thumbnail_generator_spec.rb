# frozen_string_literal: true

RSpec.describe Robots::DorRepo::WasSeedPreassembly::ThumbnailGenerator do
  describe 'perform' do
    let(:druid) { 'druid:bc123df4567' }
    let(:instance) { described_class.new }
    let(:url) { 'http://abc123.edu' }
    let(:object_client) { instance_double(Dor::Services::Client::Object, find: cocina_model) }
    let(:temp_dir) { Dir.mktmpdir }
    let(:staging_path) { "#{temp_dir}/assembly/" }
    let(:content_dir) { "#{staging_path}bc/123/df/4567/bc123df4567/content" }
    let(:cocina_model) do
      build(:dro, id: druid).new(description: {
                                   purl: 'https://purl.stanford.edu/bc123df4567',
                                   title: [{ value: url }]
                                 })
    end

    before do
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      allow(Dor::WasSeed::ThumbnailGeneratorService).to receive(:capture_thumbnail)
      allow(Settings.was_seed).to receive(:staging_path).and_return(staging_path)
    end

    after do
      FileUtils.rm_rf(temp_dir)
    end

    context 'when a jp2 has been staged' do
      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/custom.jp2")
      end

      it 'keeps the staged jp2 instead of generating a thumbnail' do
        result = test_perform(instance, druid)
        expect(result.status).to eq 'skipped'
        expect(result.note).to eq 'Using staged thumbnail custom.jp2'
        expect(File.exist?("#{content_dir}/custom.jp2")).to be true
        expect(Dor::WasSeed::ThumbnailGeneratorService).not_to have_received(:capture_thumbnail)
      end
    end

    context 'when more than one jp2 has been staged' do
      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/a.jp2")
        FileUtils.touch("#{content_dir}/b.jp2")
      end

      it 'raises an error without generating a thumbnail' do
        expect { test_perform(instance, druid) }.to raise_error(/Expected at most one jp2/)
        expect(Dor::WasSeed::ThumbnailGeneratorService).not_to have_received(:capture_thumbnail)
      end
    end

    context 'when only non-jp2 files have been staged' do
      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/notes.txt")
      end

      it 'generates a thumbnail' do
        test_perform(instance, druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, content_dir, url)
      end
    end

    context 'when the structure already has a published jp2' do
      let(:cocina_model) do
        with_jp2_structural(build(:dro, id: druid).new(description: { purl: 'https://purl.stanford.edu/bc123df4567', title: [{ value: url }] }),
                            publish: true)
      end

      it 'keeps the existing thumbnail' do
        result = test_perform(instance, druid)
        expect(result.status).to eq 'skipped'
        expect(Dor::WasSeed::ThumbnailGeneratorService).not_to have_received(:capture_thumbnail)
      end
    end

    context 'when the structure has an unpublished jp2' do
      let(:cocina_model) do
        with_jp2_structural(build(:dro, id: druid).new(description: { purl: 'https://purl.stanford.edu/bc123df4567', title: [{ value: url }] }),
                            publish: false)
      end

      it 'generates a thumbnail' do
        test_perform(instance, druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, content_dir, url)
      end
    end

    context 'when a jp2 has been staged and the structure already has a published jp2' do
      let(:cocina_model) do
        with_jp2_structural(build(:dro, id: druid).new(description: { purl: 'https://purl.stanford.edu/bc123df4567', title: [{ value: url }] }),
                            publish: true)
      end

      before do
        FileUtils.mkdir_p(content_dir)
        FileUtils.touch("#{content_dir}/new.jp2")
      end

      it 'uses the staged jp2' do
        result = test_perform(instance, druid)
        expect(result.note).to eq 'Using staged thumbnail new.jp2'
        expect(Dor::WasSeed::ThumbnailGeneratorService).not_to have_received(:capture_thumbnail)
      end
    end

    context 'when generating a thumbnail when there is no note yet' do
      let(:cocina_model) do
        build(:dro, id: druid).new(description: {
                                     purl: 'https://purl.stanford.edu/bc123df4567',
                                     title: [
                                       {
                                         value: 'http://abc123.edu'
                                       }
                                     ]
                                   })
      end

      it 'invokes thumbnail generator service and finds the URI in the title' do
        test_perform(instance, druid)
        expect(Dor::Services::Client).to have_received(:object).with(druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, content_dir, url)
      end
    end

    context 'when re-generating a thumbnail' do
      let(:cocina_model) do
        build(:dro, id: druid).new(description: {
                                     purl: 'https://purl.stanford.edu/bc123df4567',
                                     note: [
                                       {
                                         value: url,
                                         displayLabel: 'Original site'
                                       }
                                     ],
                                     title: [
                                       {
                                         value: 'Web Archive Seed for http://abc123.edu'
                                       }
                                     ]
                                   })
      end

      it 'invokes thumbnail generator service and finds the URI in the note' do
        test_perform(instance, druid)
        expect(Dor::Services::Client).to have_received(:object).with(druid)
        expect(Dor::WasSeed::ThumbnailGeneratorService).to have_received(:capture_thumbnail).with(druid, content_dir, url)
      end
    end

    context 'when re-generating the thumbnail and title has been updated and there is no note' do
      let(:cocina_model) do
        build(:dro, id: druid).new(description: {
                                     purl: 'https://purl.stanford.edu/bc123df4567',
                                     title: [
                                       {
                                         value: 'Web Archive Seed for http://abc123.edu'
                                       }
                                     ]
                                   })
      end

      it 'raises an error' do
        expect { test_perform(instance, druid) }.to raise_error(StandardError)
      end
    end
  end
end
