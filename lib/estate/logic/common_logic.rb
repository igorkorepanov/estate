# frozen_string_literal: true

module Estate
  module Logic
    module CommonLogic
      def validate_state_changes(instance, from_state, to_state)
        if from_state == to_state
          if from_state.nil? && !Estate::Configuration.allow_empty_initial_state
            add_error(instance, "empty `#{Estate::Configuration.column_name}` is not allowed")
          end
        elsif to_state.nil?
          add_error(instance, 'transition to empty state is not allowed')
        elsif !Estate::StateMachine.state_exists?(to_state)
          add_error(instance, "state `#{to_state}` is not defined")
        elsif !transition_allowed?(from_state, to_state)
          add_error(instance, "transition from `#{from_state}` to `#{to_state}` is not allowed",
                    attribute: Estate::Configuration.column_name)
        end
      end

      def transition_allowed?(from_state, to_state)
        from_state.nil? || Estate::StateMachine.transition_exists?(from_state, to_state)
      end
    end
  end
end
