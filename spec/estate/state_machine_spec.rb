# frozen_string_literal: true

RSpec.describe Estate::StateMachine do
  let(:symbol_state) { :created }
  let(:string_state) { 'created' }
  let(:state_machine_name) { 'SomeClassName' }
  let(:column_name) { 'some_column_name' }
  let(:empty_initial_state) { true }
  let(:raise_on_error) { true }

  describe '.init' do
    it 'initialises a config' do
      described_class.init(state_machine_name, column_name, empty_initial_state, raise_on_error)
      expect(described_class.state_machines[state_machine_name]).to eq({
                                                                         config: {
                                                                           column_name: column_name,
                                                                           empty_initial_state: empty_initial_state,
                                                                           raise_on_error: raise_on_error
                                                                         },
                                                                         states: {},
                                                                         transitions: {}
                                                                       })
    end
  end

  describe '.state_exists?' do
    before { described_class.init(state_machine_name, column_name, empty_initial_state, raise_on_error) }

    it { expect(described_class.state_exists?(state_machine_name, :non_existing_state)).to eq false }

    it 'returns `true` when the state exists with symbol' do
      described_class.register_state(state_machine_name, symbol_state)
      expect(described_class.state_exists?(state_machine_name, symbol_state)).to eq true
    end

    it 'returns `true` when the state exists with string' do
      described_class.register_state(state_machine_name, string_state.to_sym)
      expect(described_class.state_exists?(state_machine_name, string_state)).to eq true
    end
  end

  describe '.register_state' do
    before { described_class.init(state_machine_name, column_name, empty_initial_state, raise_on_error) }

    it 'registers a state with a symbol' do
      expect(described_class.state_machines[state_machine_name][:states].key?(symbol_state)).to eq false
      described_class.register_state(state_machine_name, symbol_state)
      expect(described_class.state_machines[state_machine_name][:states].key?(symbol_state)).to eq true
    end

    it 'registers a state with a string' do
      expect(described_class.state_machines[state_machine_name][:states].key?(string_state.to_sym)).to eq false
      described_class.register_state(state_machine_name, string_state)
      expect(described_class.state_machines[state_machine_name][:states].key?(string_state.to_sym)).to eq true
    end
  end

  describe '.transition_exists?' do
    let(:new_transition) { { from: :start, to: :end } }

    before { described_class.init(state_machine_name, column_name, empty_initial_state, raise_on_error) }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'returns true when the transition exists' do
      expect(described_class.transition_exists?(state_machine_name, new_transition[:from], new_transition[:to])).to eq false
      expect { described_class.register_transition(state_machine_name, new_transition[:from], new_transition[:to]) }.not_to raise_error
      expect(described_class.transition_exists?(state_machine_name, new_transition[:from], new_transition[:to])).to eq true
    end

    it 'returns false when the transition does not exist' do
      expect(described_class.transition_exists?(state_machine_name, :start, :nonexistent_state)).to eq false
    end
  end

  describe '.register_transition' do
    let(:new_transition) { { from: :start, to: :end } }

    before { described_class.init(state_machine_name, column_name, empty_initial_state, raise_on_error) }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'registers the transition' do
      expect(described_class.transition_exists?(state_machine_name, new_transition[:from], new_transition[:to])).to eq false
      expect { described_class.register_transition(state_machine_name, new_transition[:from], new_transition[:to]) }.not_to raise_error
      expect(described_class.transition_exists?(state_machine_name, new_transition[:from], new_transition[:to])).to eq true
    end
  end

  describe '.argument_valid?' do
    it { expect(described_class.argument_valid?(1)).to eq false }

    it { expect(described_class.argument_valid?(nil)).to eq false }

    it { expect(described_class.argument_valid?('string_arg')).to eq true }

    it { expect(described_class.argument_valid?(:symbol_arg)).to eq true }
  end
end
