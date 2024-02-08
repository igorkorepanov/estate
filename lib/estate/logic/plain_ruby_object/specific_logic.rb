# frozen_string_literal: true

module Estate
  module Logic
    module PlainRubyObject
      module SpecificLogic
        module_function

        def add_error(_, message, attribute: :base)
          exception_message = attribute == :base ? message : "#{attribute}: #{message}"
          raise(StandardError, exception_message)
        end
      end
    end
  end
end
