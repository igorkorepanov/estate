# frozen_string_literal: true

module Estate
  module Logic
    module ActiveRecord
      module Setup
        module_function

        def call(base)
          base.class_eval do
            public_send(:before_validation) do
              Estate::Logic::Core.call('active_record', self) # TODO: константа
            end
          end
        end
      end
    end
  end
end
