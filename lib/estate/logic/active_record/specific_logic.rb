# frozen_string_literal: true

require 'estate/logic/base'

module Estate
  module Logic
    module ActiveRecord
      module SpecificLogic
        extend Estate::Logic::Base

        module_function

        def add_error(instance:, message:, attribute: :base)
          if Estate::Configuration.raise_on_error
            exception_message = attribute == :base ? message : "#{attribute}: #{message}"
            raise(StandardError, exception_message)
          else
            instance.errors.add(attribute, message) unless instance.errors[attribute].include?(message)
          end
        end
      end
    end
  end
end
