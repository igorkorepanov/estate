# frozen_string_literal: true

module Estate
  module Logic
    module ActiveRecord
      module SpecificLogic
        module_function

        def add_error(instance, message, attribute: :base)
          if config_for(instance)[:raise_on_error]
            exception_message = attribute == :base ? message : "#{attribute}: #{message}"
            raise(StandardError, exception_message)
          else
            instance.errors.add(attribute, message) unless instance.errors[attribute].include?(message)
          end
        end

        def get_states(instance)
          from_state = instance.public_send("#{config_for(instance)[:column_name]}_was")
          to_state = instance.public_send(config_for(instance)[:column_name])
          [from_state, to_state]
        end
      end
    end
  end
end
