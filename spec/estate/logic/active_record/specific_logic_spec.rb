# frozen_string_literal: true

require 'estate/logic/active_record/specific_logic'

RSpec.describe Estate::Logic::ActiveRecord::SpecificLogic do
  let(:instance) { double }

  before { allow(described_class).to receive(:config_for).with(instance).and_return(config) }

  describe '.add_error' do
    let(:message) { 'some message' }
    let(:attribute) { :state }
    let(:config) { { raise_on_error: raise_on_error } }
    let(:raise_on_error) { true }

    context 'with enabled raise_on_error' do
      it 'raises an error' do
        expect { described_class.add_error(instance, message, attribute: attribute) }.to raise_error(StandardError, "#{attribute}: #{message}")
      end
    end

    context 'with disabled raise_on_error' do
      let(:raise_on_error) { false }
      let(:errors_stub) { double }

      before do
        allow(instance).to receive(:errors).and_return(errors_stub)
        allow(errors_stub).to receive(:[]).with(attribute).and_return(messages)
        allow(errors_stub).to receive(:add)
      end

      context 'with new message' do
        let(:messages) { [] }

        it 'adds an error' do
          described_class.add_error(instance, message, attribute: attribute)
          expect(errors_stub).to have_received(:add).with(attribute, message)
        end
      end

      context 'with existing message' do
        let(:messages) { [message] }

        it 'does not add an error' do
          described_class.add_error(instance, message, attribute: attribute)
          expect(errors_stub).not_to have_received(:add)
        end
      end
    end
  end

  describe '.get_states' do
    let(:config) { { column_name: column_name } }
    let(:column_name) { 'some_column_name' }
    let(:old_value) { 'column_name_was' }
    let(:new_value) { 'column_name_now' }

    it 'returns states' do
      allow(instance).to receive("#{config[:column_name]}_was").and_return(old_value)
      allow(instance).to receive(config[:column_name]).and_return(new_value)
      expect(described_class.get_states(instance)).to eq [old_value, new_value]
    end
  end
end
