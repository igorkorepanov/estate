# frozen_string_literal: true

module Estate
  module Db
    module Sequel
      module_function

      def setup_callbacks(base)
        base.class_eval do
          def validate
            super

            to_state = values[Estate::Configuration.column_name]
            from_state, = column_change(Estate::Configuration.column_name)
            Estate::Db::Sequel.validate_state_changes(self, from_state, to_state)
          end
        end
      end

      def validate_state_changes(instance, from_state, to_state)
        if from_state == to_state
          if from_state.nil? && !Estate::Configuration.allow_empty_initial_state
            add_error(instance: instance, message: "empty `#{Estate::Configuration.column_name}` is not allowed")
          end
        elsif to_state.nil?
          add_error(instance: instance, message: 'transition to empty state is not allowed')
        elsif !Estate::StateMachine.state_exists?(to_state)
          add_error(instance: instance, message: "state `#{to_state}` is not defined")
        elsif !transition_allowed?(from_state: from_state, to_state: to_state)
          add_error(instance: instance, message: "transition from `#{from_state}` to `#{to_state}` is not allowed",
                    attribute: Estate::Configuration.column_name)
        end
      end

      # TODO: remove base
      def add_error(instance:, message:, attribute: :base)
        instance.errors.add(attribute, message)
      end

      def transition_allowed?(from_state:, to_state:)
        from_state.nil? || Estate::StateMachine.transition_exists?(from: from_state, to: to_state)
      end
    end
  end
end