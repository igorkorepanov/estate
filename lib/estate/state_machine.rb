# frozen_string_literal: true

module Estate
  class StateMachine
    class << self
      def create_store
        @states = {}
        @transitions = {}
      end

      def state_exists?(state)
        states.key?(state.to_sym)
      end

      def register_state(state)
        states[state.to_sym] = nil
      end

      def transition_exists?(from_state, to_state)
        transition_key = { from: from_state.to_sym, to: to_state.to_sym }
        transitions.key?(transition_key)
      end

      def register_transition(from_state, to_state)
        transition_key = { from: from_state.to_sym, to: to_state.to_sym }
        transitions[transition_key] = nil
      end

      def argument_valid?(argument)
        argument.is_a?(Symbol) || argument.is_a?(String)
      end

      attr_reader :states, :transitions
    end
  end
end
