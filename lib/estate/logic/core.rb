# frozen_string_literal: true

module Estate
  module Logic
    module Core
      module_function

      def call(orm, instance)
        require 'estate/logic/common_logic'
        require File.join(File.dirname(__FILE__), orm, 'specific_logic')

        extend Estate::Logic::CommonLogic
        extend "Estate::Logic::#{orm.classify}::SpecificLogic".safe_constantize

        validate_state_changes(instance, *get_states(instance))
      end
    end
  end
end
