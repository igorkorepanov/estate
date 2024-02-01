# frozen_string_literal: true

RSpec.describe Estate::Logic::Core do
  describe '.call' do
    let(:common_logic) { stub_const('Estate::Logic::CommonLogic', Module.new) }
    let(:instance) { double }
    let(:states_stub) { [1, 2] }

    before do
      common_logic
      allow(described_class).to receive(:require)
      allow(described_class).to receive(:extend)
      allow(described_class).to receive(:get_states).and_return(states_stub)
      allow(described_class).to receive(:validate_state_changes)
    end

    context 'with ActiveRecord' do
      it 'requires necessary files' do
        active_record = stub_const('Estate::Logic::ActiveRecord::SpecificLogic', Module.new)
        described_class.call(Estate::Constants::Orm::ACTIVE_RECORD, instance)
        expect(described_class).to have_received(:require).with('estate/logic/common_logic')
        expect(described_class).to have_received(:require).with('estate/logic/active_record/specific_logic')
        expect(described_class).to have_received(:extend).with(common_logic)
        expect(described_class).to have_received(:extend).with(active_record)
        expect(described_class).to have_received(:get_states).with(instance)
        expect(described_class).to have_received(:validate_state_changes).with(instance, *states_stub)
      end
    end

    context 'with Sequel' do
      it 'requires necessary files' do
        sequel = stub_const('Estate::Logic::Sequel::SpecificLogic', Module.new)
        described_class.call(Estate::Constants::Orm::SEQUEL, instance)
        expect(described_class).to have_received(:require).with('estate/logic/common_logic')
        expect(described_class).to have_received(:require).with('estate/logic/sequel/specific_logic')
        expect(described_class).to have_received(:extend).with(common_logic)
        expect(described_class).to have_received(:extend).with(sequel)
        expect(described_class).to have_received(:get_states).with(instance)
        expect(described_class).to have_received(:validate_state_changes).with(instance, *states_stub)
      end
    end
  end
end
