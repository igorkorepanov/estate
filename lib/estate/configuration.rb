# frozen_string_literal: true

module Estate
  module Configuration
    class << self
      def init_config(column_name, allow_empty_initial_state, raise_on_error)
        @column_name = column_name
        @allow_empty_initial_state = allow_empty_initial_state
        @raise_on_error = raise_on_error
      end

      attr_reader :column_name, :allow_empty_initial_state, :raise_on_error
    end

    module Defaults
      COLUMN_NAME = :state
      ALLOW_EMPTY_INITIAL_STATE = false
      RAISE_ON_ERROR = false
    end
  end
end
