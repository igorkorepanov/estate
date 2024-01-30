# frozen_string_literal: true

module Estate
  class StateMachine
    class << self
      def init(state_machine_name, column_name, empty_initial_state, raise_on_error)
        @state_machines ||= {}
        @state_machines[state_machine_name] = {
          config: {
            column_name: column_name,
            empty_initial_state: empty_initial_state, # TODO: allow_empty_initial_state ?
            raise_on_error: raise_on_error
          },
          states: {},
          transitions: {}
        }
      end

      def state_exists?(state_machine_name, state_name)
        state_machines[state_machine_name][:states].key?(state_name.to_sym)
      end

      def register_state(state_machine_name, state_name)
        state_machines[state_machine_name][:states][state_name.to_sym] = nil
      end

      def transition_exists?(state_machine_name, from_state, to_state)
        transition_key = { from: from_state.to_sym, to: to_state.to_sym }
        state_machines[state_machine_name][:transitions].key?(transition_key)
      end

      def register_transition(state_machine_name, from_state, to_state)
        transition_key = { from: from_state.to_sym, to: to_state.to_sym }
        state_machines[state_machine_name][:transitions][transition_key] = nil
      end

      def argument_valid?(argument)
        argument.is_a?(Symbol) || argument.is_a?(String)
      end

      attr_reader :state_machines
    end
  end
end
