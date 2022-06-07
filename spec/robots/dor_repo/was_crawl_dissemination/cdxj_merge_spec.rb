# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robots::DorRepo::WasCrawlDissemination::CdxjMerge do
  subject(:robot) { described_class.new }

  describe '.perform' do
    subject(:perform) { robot.perform(druid) }

    let(:druid) { 'druid:dd116zh0343' }

    it 'returns a skipped status' do
      expect(perform.status).to eq('skipped')
    end
  end
end
