# frozen_string_literal: true

require 'estate/logic/common_logic'
require 'estate/logic/plain_ruby_object/specific_logic'

module Estate
  module Logic
    module PlainRubyObject
      module Setup
        module_function

        def call(base)
          base.prepend(Module.new do
            extend Estate::Logic::CommonLogic

            define_method("#{config_for(base)[:column_name]}=") do |new_value|
              extend Estate::Logic::CommonLogic
              extend Estate::Logic::PlainRubyObject::SpecificLogic

              validate_state_changes(self, state, new_value)

              super(new_value)
            end
          end)
        end
      end
    end
  end
end
