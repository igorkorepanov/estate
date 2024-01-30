# frozen_string_literal: true

RSpec.describe Estate::Configuration do
  describe 'Defaults' do
    it 'has default COLUMN_NAME' do
      expect(described_class::Defaults::COLUMN_NAME).to eq :state
    end

    it 'has default ALLOW_EMPTY_INITIAL_STATE' do
      expect(described_class::Defaults::ALLOW_EMPTY_INITIAL_STATE).to eq false
    end

    it 'has default RAISE_ON_ERROR' do
      expect(described_class::Defaults::RAISE_ON_ERROR).to eq false
    end
  end
end
