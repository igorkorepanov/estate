# frozen_string_literal: true

require 'estate/logic/sequel/specific_logic'

RSpec.describe Estate::Logic::Sequel::SpecificLogic do
  let(:instance) { double }

  describe '.add_error' do
    let(:message) { 'some message' }
    let(:attribute) { :state }
    let(:errors_stub) { double }

    before do
      allow(instance).to receive(:errors).and_return(errors_stub)
      allow(errors_stub).to receive(:add)
    end

    it 'adds and error' do
      described_class.add_error(instance, message, attribute: attribute)
      expect(errors_stub).to have_received(:add).with(attribute, message)
    end
  end

  describe '.get_states' do
    let(:config) { { column_name: column_name } }
    let(:column_name) { 'some_column_name' }
    let(:old_value) { 'column_name_was' }
    let(:new_value) { 'column_name_now' }

    before { allow(described_class).to receive(:config_for).with(instance).and_return(config) }

    it 'returns states' do
      allow(instance).to receive(:column_change).with(config[:column_name]).and_return([old_value, :some_value])
      allow(instance).to receive(:values).and_return({ column_name => new_value })
      expect(described_class.get_states(instance)).to eq [old_value, new_value]
    end
  end
end
