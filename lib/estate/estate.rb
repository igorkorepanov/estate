# frozen_string_literal: true

module Estate
  def self.included(base)
    base.extend Estate::ClassMethods

    Estate::Requirements.check_requirements(base)
    Estate::Setup.call(base)
  end

  module ClassMethods
    def estate(column: Estate::Configuration::Defaults::COLUMN_NAME,
               empty_initial_state: Estate::Configuration::Defaults::ALLOW_EMPTY_INITIAL_STATE,
               raise_on_error: Estate::Configuration::Defaults::RAISE_ON_ERROR)
      Estate::StateMachine.init(name, column, empty_initial_state, raise_on_error)

      yield if block_given?
    end

    def state(state_name = nil)
      raise(StandardError, 'state must be a Symbol or a String') unless Estate::StateMachine.argument_valid?(state_name)

      if Estate::StateMachine.state_exists?(name, state_name)
        raise(StandardError, "state `:#{state_name}` is already defined")
      else
        Estate::StateMachine.register_state(name, state_name)
      end
    end

    def transition(from: nil, to: nil)
      unless Estate::StateMachine.argument_valid?(from)
        raise(StandardError, 'argument `from` must be a Symbol or a String')
      end

      raise(StandardError, 'argument `to` must be a Symbol or a String') unless Estate::StateMachine.argument_valid?(to)

      raise(StandardError, "state `#{from}` is not defined") unless Estate::StateMachine.state_exists?(name, from)

      raise(StandardError, "state `#{to}` is not defined") unless Estate::StateMachine.state_exists?(name, to)

      if Estate::StateMachine.transition_exists?(name, from, to)
        raise(StandardError, "`transition from: :#{from}, to: :#{to}` already defined")
      end

      Estate::StateMachine.register_transition(name, from, to)
    end
  end
end
