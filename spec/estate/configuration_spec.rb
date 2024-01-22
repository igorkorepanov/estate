# frozen_string_literal: true

RSpec.describe Estate::Configuration do
  describe 'Defaults' do
    it 'has default COLUMN_NAME' do
      expect(described_class::Defaults::COLUMN_NAME).to eq :state
    end

    it 'has default ALLOW_EMPTY_INITIAL_STATE' do
      expect(described_class::Defaults::ALLOW_EMPTY_INITIAL_STATE).to eq false
    end
  end

  describe '.init_config' do
    let(:column_name) { :custom_name }
    let(:allow_empty_initial_state) { true }

    before { described_class.init_config(column_name: column_name, allow_empty_initial_state: allow_empty_initial_state) }

    it 'can set and retrieve the custom COLUMN_NAME' do
      expect(described_class.column_name).to eq column_name
    end

    it 'can set and retrieve the custom ALLOW_EMPTY_INITIAL_STATE' do
      expect(described_class.allow_empty_initial_state).to eq allow_empty_initial_state
    end
  end
end
