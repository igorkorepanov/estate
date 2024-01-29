# frozen_string_literal: true

require 'estate/logic/common_logic'

RSpec.describe Estate::Logic::CommonLogic do
  let(:base_module) { Module.new { extend Estate::Logic::CommonLogic } }
  let(:state_machine) { stub_const('Estate::StateMachine', Module.new) }

  describe '.validate_state_changes' do
    let(:instance) { double }
    let(:configuration) { stub_const('Estate::Configuration', Module.new) }
    let(:column_name) { :some_column_name }

    before do
      allow(base_module).to receive(:add_error)
      allow(configuration).to receive(:column_name).and_return(column_name)
    end

    context 'with nil from_state and to_state' do
      before { allow(configuration).to receive(:allow_empty_initial_state).and_return(allow_empty_initial_state) }

      context 'with allowed empty initial state' do
        let(:allow_empty_initial_state) { true }

        it 'does not add an error' do
          base_module.validate_state_changes(instance, nil, nil)
          expect(base_module).not_to have_received(:add_error)
        end
      end

      context 'with disallowed empty initial state' do
        let(:allow_empty_initial_state) { false }

        it 'adds an error' do
          base_module.validate_state_changes(instance, nil, nil)
          expect(base_module).to have_received(:add_error).with(instance, "empty `#{column_name}` is not allowed")
        end
      end
    end

    context 'with existing from_state and nil to_state' do
      it 'adds an error' do
        base_module.validate_state_changes(instance, :some_state, nil)
        expect(base_module).to have_received(:add_error).with(instance, 'transition to empty state is not allowed')
      end
    end

    context 'with non-existing state' do
      let(:non_existing_state) { :non_existing_state }

      it 'adds an error' do
        allow(state_machine).to receive(:state_exists?).and_return(false)
        base_module.validate_state_changes(instance, :some_state, non_existing_state)
        expect(base_module).to have_received(:add_error).with(instance, "state `#{non_existing_state}` is not defined")
      end
    end

    context 'with disallowed transition' do
      let(:from_state) { :from_state }
      let(:to_state) { :forbidden_to_state }

      it 'adds an error' do
        allow(state_machine).to receive(:state_exists?).and_return(true)
        allow(base_module).to receive(:transition_allowed?).with(from_state, to_state).and_return(false)
        base_module.validate_state_changes(instance, from_state, to_state)
        expect(base_module).to have_received(:add_error).with(instance, "transition from `#{from_state}` to `#{to_state}` is not allowed", attribute: Estate::Configuration.column_name)
      end
    end

    context 'with valid conditions' do
      let(:from_state) { :from_state }
      let(:to_state) { :forbidden_to_state }

      it 'does not add an error' do
        allow(state_machine).to receive(:state_exists?).and_return(true)
        allow(base_module).to receive(:transition_allowed?).with(from_state, to_state).and_return(true)
        base_module.validate_state_changes(instance, from_state, to_state)
        expect(base_module).not_to have_received(:add_error)
      end
    end
  end

  describe '.transition_allowed?' do
    # the model has just been initialized, all transitions are allowed
    context 'with empty initial state' do
      it { expect(base_module.transition_allowed?(nil, :some_state)).to eq true }
    end

    context 'with existing initial state' do
      it 'returns true' do
        allow(Estate::StateMachine).to receive(:transition_exists?).and_return(true)
        expect(base_module.transition_allowed?(:some_initial_state, :some_state)).to eq true
        expect(Estate::StateMachine).to have_received(:transition_exists?).with(:some_initial_state, :some_state)
      end

      it 'returns false' do
        allow(Estate::StateMachine).to receive(:transition_exists?).and_return(false)
        expect(base_module.transition_allowed?(:some_initial_state, :some_state)).to eq false
        expect(Estate::StateMachine).to have_received(:transition_exists?).with(:some_initial_state, :some_state)
      end
    end
  end
end
