# frozen_string_literal: true

module Estate
  module Logic
    module Sequel
      module Setup
        module_function

        def call(base)
          base.class_eval do
            def validate
              super

              Estate::Logic::Core.call(Estate::Constants::Orm::SEQUEL, self)
            end
          end
        end
      end
    end
  end
end