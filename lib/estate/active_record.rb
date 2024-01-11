# frozen_string_literal: true

module Estate
  module ActiveRecord
    CALLBACK_NAMES = [:before_validation].freeze

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
        if to_state.nil? && !Estate::Configuration.allow_empty_initial_state
          raise(StandardError, "empty `#{Estate::Configuration.column_name}` is not allowed")
        end
      elsif Estate::StateMachine.state_exists?(to_state) # TODO: check to_state.nil?
        unless Estate::StateMachine.transition_exists?(from: from_state, to: to_state)
          instance.errors.add(Estate::Configuration.column_name,
                              message: "transition from `#{from_state}` to `#{to_state}` is not allowed")
        end
      else
        instance.errors.add(:base, "state `#{to_state}` is not defined")
      end
    end

    module_function :setup_callbacks, :validate_state_changes
  end
end
