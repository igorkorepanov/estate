# frozen_string_literal: true

require 'estate/new_core/base'

module Estate
  module NewCore
    module Sequel
      extend Estate::NewCore::Base

      module_function

      def add_error(instance:, message:, attribute: :base)
        instance.errors.add(attribute, message)
      end
    end
  end
end
