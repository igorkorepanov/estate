# frozen_string_literal: true

require 'estate/logic/common_logic'
require 'estate/logic/active_record/specific_logic'

module Estate
  module Logic
    module ActiveRecord
      module Setup
        module_function

        def call(base)
          base.class_eval do
            public_send(:before_validation) do
              extend Estate::Logic::CommonLogic
              extend Estate::Logic::ActiveRecord::SpecificLogic
              validate_state_changes(self, *get_states(self))
            end
          end
        end
      end
    end
  end
end
