# frozen_string_literal: true

module Estate
  class StateMachine
    class << self
      def create_store
        @states = {}
        @transitions = {}
      end

      def state_exists?(state)
        !state.nil? && states.key?(state.to_sym)
      end

      def register_state(state)
        case state
        when Symbol
          states[state] = nil
        when String
          states[state.to_sym] = nil
        else
          raise(ArgumentError, 'State must be a Symbol or a String')
        end
      end

      def transition_exists?(from:, to:)
        transition_key = { from: from.to_sym, to: to.to_sym }
        transitions.key?(transition_key)
      end

      def register_transition(from:, to:)
        # TODO: validate from and to
        transition_key = { from: from.to_sym, to: to.to_sym }
        transitions[transition_key] = nil
      end

      attr_reader :states, :transitions
    end
  end
end
