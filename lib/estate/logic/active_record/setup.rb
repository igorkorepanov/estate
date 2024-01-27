# frozen_string_literal: true

module Estate
  module Logic
    module ActiveRecord
      module Setup
        module_function

        def setup(base)
          base.class_eval do
            public_send(:before_validation) do
              from_state = public_send("#{Estate::Configuration.column_name}_was")
              to_state = public_send(Estate::Configuration.column_name)
              Estate::Logic::ActiveRecord::SpecificLogic.validate_state_changes(self, from_state, to_state)
            end
          end
        end
      end
    end
  end
end
