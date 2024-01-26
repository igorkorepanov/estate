# frozen_string_literal: true

module Estate
  module Db
    module ActiveRecord
      module_function

      def setup_callbacks(base)
        base.class_eval do
          public_send(:before_validation) do
            from_state = public_send("#{Estate::Configuration.column_name}_was")
            to_state = public_send(Estate::Configuration.column_name)
            Estate::Db::ActiveRecord.validate_state_changes(self, from_state, to_state)
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

      def add_error(instance:, message:, attribute: :base)
        if Estate::Configuration.raise_on_error
          exception_message = attribute == :base ? message : "#{attribute}: #{message}"
          raise(StandardError, exception_message)
        else
          instance.errors.add(attribute, message) unless instance.errors[attribute].include?(message)
        end
      end

      def transition_allowed?(from_state:, to_state:)
        from_state.nil? || Estate::StateMachine.transition_exists?(from: from_state, to: to_state)
      end
    end
  end
end
