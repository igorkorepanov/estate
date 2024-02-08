# frozen_string_literal: true

require 'estate/logic/common_logic'
require 'estate/logic/sequel/specific_logic'

module Estate
  module Logic
    module Sequel
      module Setup
        module_function

        def call(base)
          base.class_eval do
            def validate
              super

              extend Estate::Logic::CommonLogic
              extend Estate::Logic::Sequel::SpecificLogic
              validate_state_changes(self, *get_states(self))
            end
          end
        end
      end
    end
  end
end
