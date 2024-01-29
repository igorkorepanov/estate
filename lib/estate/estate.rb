# frozen_string_literal: true

module Estate
  def self.included(base)
    base.extend Estate::ClassMethods

    Estate::Requirements.check_requirements(base)
    Estate::StateMachine.create_store
    Estate::Setup.call(base)
  end

  module ClassMethods
    def estate(column: Estate::Configuration::Defaults::COLUMN_NAME,
               empty_initial_state: Estate::Configuration::Defaults::ALLOW_EMPTY_INITIAL_STATE,
               raise_on_error: Estate::Configuration::Defaults::RAISE_ON_ERROR)
      Estate::Configuration.init_config(column, empty_initial_state, raise_on_error)

      yield if block_given?
    end

    def state(name = nil)
      raise(StandardError, 'state must be a Symbol or a String') unless Estate::StateMachine.argument_valid?(name)

      if Estate::StateMachine.state_exists?(name)
        raise(StandardError, "state `:#{name}` is already defined")
      else
        Estate::StateMachine.register_state(name)
      end
    end

    def transition(from: nil, to: nil)
      unless Estate::StateMachine.argument_valid?(from)
        raise(StandardError, 'argument `from` must be a Symbol or a String')
      end

      raise(StandardError, 'argument `to` must be a Symbol or a String') unless Estate::StateMachine.argument_valid?(to)

      raise(StandardError, "state `#{from}` is not defined") unless Estate::StateMachine.state_exists?(from)

      raise(StandardError, "state `#{to}` is not defined") unless Estate::StateMachine.state_exists?(to)

      if Estate::StateMachine.transition_exists?(from, to)
        raise(StandardError, "`transition from: :#{from}, to: :#{to}` already defined")
      end

      Estate::StateMachine.register_transition(from, to)
    end
  end
end
