# frozen_string_literal: true

require 'estate/logic/common_logic'

module Estate
  module Logic
    module Sequel
      module SpecificLogic
        extend Estate::Logic::CommonLogic

        module_function

        def add_error(instance:, message:, attribute: :base)
          instance.errors.add(attribute, message)
        end

        def get_states(instance)
          from_state, = instance.column_change(Estate::Configuration.column_name)
          to_state = instance.values[Estate::Configuration.column_name]
          [from_state, to_state]
        end
      end
    end
  end
end