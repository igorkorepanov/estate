# frozen_string_literal: true

module Estate
  module Setup
    module_function

    def setup(base)
      if 'ActiveRecord::Base'.in? base.ancestors.map(&:to_s)
        require File.join(File.dirname(__FILE__), 'logic', 'active_record', 'setup')
        require File.join(File.dirname(__FILE__), 'logic', 'active_record', 'specific_logic')
        Estate::Logic::ActiveRecord::Setup.setup(base)
      else
        require File.join(File.dirname(__FILE__), 'logic', 'sequel', 'setup')
        require File.join(File.dirname(__FILE__), 'logic', 'sequel', 'specific_logic')
        Estate::Logic::Sequel::Setup.setup(base)
      end
    end
  end
end
