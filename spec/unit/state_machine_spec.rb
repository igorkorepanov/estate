# frozen_string_literal: true

RSpec.describe Estate::StateMachine do
  let(:symbol_state) { :created }
  let(:string_state) { 'created' }

  describe '.create_store' do
    it 'creates store' do
      expect { described_class.create_store }.to change { described_class.states }.from(nil).to({})
                                            .and change { described_class.transitions }.from(nil).to({})
    end
  end

  describe '.state_exists?' do
    # TODO: this does not need to be done if the tests are run sequentially
    # TODO: fix
    before { described_class.create_store }

    it { expect(described_class.state_exists?(nil)).to eq false }

    it { expect(described_class.state_exists?(:non_existing_state)).to eq false }

    it 'returns `true` when the state exists with symbol' do
      described_class.register_state(symbol_state)
      expect(described_class.state_exists?(symbol_state)).to eq true
    end

    it 'returns `true` when the state exists with string' do
      described_class.register_state(string_state)
      expect(described_class.state_exists?(string_state)).to eq true
    end
  end

  describe '.register_state' do
    # TODO: this does not need to be done if the tests are run sequentially
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

    it 'raises an error for an unsupported data type' do
      expect { described_class.register_state(123) }.to raise_error(ArgumentError, 'State must be a Symbol or a String')
    end
  end

  describe '.transition_exists?' do
    let(:new_transition) { { from: :start, to: :end } }

    # TODO: this does not need to be done if the tests are run sequentially
    before { described_class.create_store }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'returns true when the transition exists' do
      expect(described_class.transition_exists?(**new_transition)).to eq false
      expect { described_class.register_transition(**new_transition) }.not_to raise_error
      expect(described_class.transition_exists?(**new_transition)).to eq true
    end

    it 'returns false when the transition does not exist' do
      expect(described_class.transition_exists?(from: :start, to: :nonexistent_state)).to eq false
    end
  end

  describe '.register_transition' do
    let(:new_transition) { { from: :start, to: :end } }

    # TODO: this does not need to be done if the tests are run sequentially
    before { described_class.create_store }

    # TODO: tests for .transition_exists? and .register_transition are identical
    it 'registers the transition' do
      expect(described_class.transition_exists?(**new_transition)).to eq false
      expect { described_class.register_transition(**new_transition) }.not_to raise_error
      expect(described_class.transition_exists?(**new_transition)).to eq true
    end
  end
end