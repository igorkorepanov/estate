# frozen_string_literal: true

module Estate
  module ActiveRecord
    CALLBACK_NAMES = [:before_validation].freeze

    module_function

    def setup_callbacks(base)
      base.class_eval do
        CALLBACK_NAMES.each do |callback_name|
          public_send(callback_name) { Estate::ActiveRecord.validate_state_changes(self) }
        end
      end
    end

    def validate_state_changes(instance)
      from_state = instance.public_send("#{Estate::Configuration.column_name}_was")
      to_state = instance.public_send(Estate::Configuration.column_name)

      if from_state == to_state
        if from_state.nil? && !Estate::Configuration.allow_empty_initial_state
          add_error(instance, :base, "empty `#{Estate::Configuration.column_name}` is not allowed")
        end
      elsif to_state.nil?
        add_error(instance, :base, 'transition to empty state is not allowed')
      elsif !Estate::StateMachine.state_exists?(to_state)
        add_error(instance, :base, "state `#{to_state}` is not defined")
      elsif !transition_allowed?(from_state: from_state, to_state: to_state)
        add_error(instance, Estate::Configuration.column_name,
                  "transition from `#{from_state}` to `#{to_state}` is not allowed")
      end
    end

    def add_error(instance, attribute, message)
      instance.errors.add(attribute, message) unless instance.errors[attribute].include?(message)
    end

    def transition_allowed?(from_state:, to_state:)
      from_state.nil? || Estate::StateMachine.transition_exists?(from: from_state, to: to_state)
    end
  end
end
