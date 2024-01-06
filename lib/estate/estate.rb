# frozen_string_literal: true

module Estate
  def self.included(base)
    base.extend Estate::ClassMethods

    Estate::Requirements.check_requirements(base)
    Estate::ActiveRecord.setup_callbacks(base)
    Estate::StateMachine.create_store

    super
  end

  module ClassMethods
    def estate(column: Estate::Configuration::Defaults::COLUMN_NAME,
               empty_initial_state: Estate::Configuration::Defaults::ALLOW_EMPTY_INITIAL_STATE)
      Estate::Configuration.init_config(column_name: column, allow_empty_initial_state: empty_initial_state)

      yield if block_given?
    end

    def state(name)
      if Estate::StateMachine.state_exists?(name)
        raise(StandardError, "state `:#{name}` is already defined")
      else
        Estate::StateMachine.register_state(name)
      end
    end

    def transition(from:, to:)
      unless Estate::StateMachine.state_exists?(from)
        raise(StandardError, "state `#{from}` is not defined")
      end
      unless Estate::StateMachine.state_exists?(to)
        raise(StandardError, "state `#{to}` is not defined")
      end
      if Estate::StateMachine.transition_exists?(from: from, to: to)
        raise(StandardError, "`transition from: :#{from}, to: :#{to}` already defined")
      end

      Estate::StateMachine.register_transition(from: from, to: to)
    end
  end
end
