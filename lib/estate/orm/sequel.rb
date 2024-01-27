# frozen_string_literal: true

module Estate
  module Orm
    module Sequel
      module_function

      def setup(base)
        base.class_eval do
          def validate
            super

            to_state = values[Estate::Configuration.column_name]
            from_state, = column_change(Estate::Configuration.column_name)
            Estate::NewCore::Sequel.validate_state_changes(self, from_state, to_state)
          end
        end
      end
    end
  end
end
