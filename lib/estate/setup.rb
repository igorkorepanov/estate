# frozen_string_literal: true

module Estate
  module Setup
    module_function

    def call(base)
      if 'ActiveRecord::Base'.in? base.ancestors.map(&:to_s)
        require File.join(File.dirname(__FILE__), 'logic', 'active_record', 'setup')
        Estate::Logic::ActiveRecord::Setup.call(base)
      else
        require File.join(File.dirname(__FILE__), 'logic', 'sequel', 'setup')
        Estate::Logic::Sequel::Setup.call(base)
      end
    end
  end
end
