# frozen_string_literal: true

module Estate
  module Core
    module_function

    def setup_callbacks(base) # TODO: move?
      handlers_module = base.ancestors.map(&:to_s).include?('ActiveRecord::Base') ? Estate::ActiveRecord : Estate::Sequel

      handlers_module.setup_callbacks(base)
    end
  end
end