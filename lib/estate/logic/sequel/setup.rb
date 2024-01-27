# frozen_string_literal: true

module Estate
  module Logic
    module Sequel
      module Setup
        module_function

        def setup(base)
          base.class_eval do
            def validate
              super

              to_state = values[Estate::Configuration.column_name]
              from_state, = column_change(Estate::Configuration.column_name)
              Estate::Logic::Sequel::SpecificLogic.validate_state_changes(self, from_state, to_state)
            end
          end
        end
      end
    end
  end
end
