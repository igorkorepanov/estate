# frozen_string_literal: true

module Estate
  module Logic
    module Sequel
      module SpecificLogic
        module_function

        # TODO: remove :base
        def add_error(instance, message, attribute: :base)
          instance.errors.add(attribute, message)
        end

        def get_states(instance)
          from_state, = instance.column_change(config_for(instance)[:column_name])
          to_state = instance.values[config_for(instance)[:column_name]]
          [from_state, to_state]
        end
      end
    end
  end
end
