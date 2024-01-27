# frozen_string_literal: true

require 'estate/logic/common_logic'

module Estate
  module Logic
    module ActiveRecord
      module SpecificLogic
        extend Estate::Logic::CommonLogic

        module_function

        def add_error(instance:, message:, attribute: :base)
          if Estate::Configuration.raise_on_error
            exception_message = attribute == :base ? message : "#{attribute}: #{message}"
            raise(StandardError, exception_message)
          else
            instance.errors.add(attribute, message) unless instance.errors[attribute].include?(message)
          end
        end

        def get_states(instance)
          from_state = instance.public_send("#{Estate::Configuration.column_name}_was")
          to_state = instance.public_send(Estate::Configuration.column_name)
          [from_state, to_state]
        end
      end
    end
  end
end
