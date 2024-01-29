# frozen_string_literal: true

RSpec.describe Estate::StateMachine do
  let(:symbol_state) { :created }
  let(:string_state) { 'created' }

  describe '.create_store' do
    it 'creates store' do
      expect { described_class.create_store }.to change(described_class, :states).from(nil).to({})
                                            .and change(described_class, :transitions).from(nil).to({})
    end
  end

  describe '.state_exists?' do
    before { described_class.create_store }

    it { expect(described_class.state_exists?(:non_existing_state)).to eq false }

    it 'returns `true` when the state exists with symbol' do
      described_class.register_state(symbol_state)
      expect(described_class.state_exists?(symbol_state)).to eq true
    end

    it 'returns `true` when the state exists with string' do
      described_class.register_state(string_state.to_sym)
      expect(described_class.state_exists?(string_state)).to eq true
    end
  end

  describe '.register_state' do
    before { described_class.create_store }

    it 'registers a state with a symbol' do
      expect(described_class.states.key?(symbol_state)).to eq false
      described_class.register_state(symbol_state)
      expect(described_class.states.key?(symbol_state)).to eq true
    end

    it 'registers a state with a string' do
      expect(described_class.states.key?(string_state.to_sym)).to eq false
      described_class.register_state(string_state)
      expect(described_class.states.key?(string_state.to_sym)).to eq true
    end
  end

  describe '.transition_exists?' do
    let(:new_transition) { { from: :start, to: :end } }

    before { described_class.create_store }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'returns true when the transition exists' do
      expect(described_class.transition_exists?(new_transition[:from], new_transition[:to])).to eq false
      expect { described_class.register_transition(new_transition[:from], new_transition[:to]) }.not_to raise_error
      expect(described_class.transition_exists?(new_transition[:from], new_transition[:to])).to eq true
    end

    it 'returns false when the transition does not exist' do
      expect(described_class.transition_exists?(:start, :nonexistent_state)).to eq false
    end
  end

  describe '.register_transition' do
    let(:new_transition) { { from: :start, to: :end } }

    before { described_class.create_store }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'registers the transition' do
      expect(described_class.transition_exists?(new_transition[:from], new_transition[:to])).to eq false
      expect { described_class.register_transition(new_transition[:from], new_transition[:to]) }.not_to raise_error
      expect(described_class.transition_exists?(new_transition[:from], new_transition[:to])).to eq true
    end
  end

  describe '.argument_valid?' do
    it { expect(described_class.argument_valid?(1)).to eq false }

    it { expect(described_class.argument_valid?(nil)).to eq false }

    it { expect(described_class.argument_valid?('string_arg')).to eq true }

    it { expect(described_class.argument_valid?(:symbol_arg)).to eq true }
  end
end
