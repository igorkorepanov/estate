# frozen_string_literal: true

module Estate
  module Logic
    module CommonLogic
      def validate_state_changes(instance, from_state, to_state)
        state_machine_name = instance.class.name

        if from_state == to_state
          if from_state.nil? && !config_for(instance)[:empty_initial_state]
            add_error(instance, "empty `#{config_for(instance)[:column_name]}` is not allowed")
          end
        elsif to_state.nil?
          add_error(instance, 'transition to empty state is not allowed')
        elsif !Estate::StateMachine.state_exists?(state_machine_name, to_state)
          add_error(instance, "state `#{to_state}` is not defined")
        elsif !transition_allowed?(state_machine_name, from_state, to_state)
          add_error(instance, "transition from `#{from_state}` to `#{to_state}` is not allowed",
                    attribute: config_for(instance)[:column_name])
        end
      end

      def transition_allowed?(state_machine_name, from_state, to_state)
        from_state.nil? || Estate::StateMachine.transition_exists?(state_machine_name, from_state, to_state)
      end

      def config_for(instance)
        state_machine_name = instance.class.name
        Estate::StateMachine.state_machines[state_machine_name][:config]
      end
    end
  end
end
