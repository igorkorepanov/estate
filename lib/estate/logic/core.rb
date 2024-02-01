# frozen_string_literal: true

module Estate
  module Logic
    module Core
      module_function

      def call(orm, instance)
        require 'estate/logic/common_logic'
        require "estate/logic/#{orm}/specific_logic"

        extend Estate::Logic::CommonLogic
        orm_class_name = orm.split('_').map(&:capitalize).join
        extend const_get("Estate::Logic::#{orm_class_name}::SpecificLogic")

        validate_state_changes(instance, *get_states(instance))
      end
    end
  end
end
