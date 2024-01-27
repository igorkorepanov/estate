# frozen_string_literal: true

require 'estate/logic/base'

module Estate
  module Logic
    module Sequel
      module SpecificLogic
        extend Estate::Logic::Base

        module_function

        def add_error(instance:, message:, attribute: :base)
          instance.errors.add(attribute, message)
        end
      end
    end
  end
end
