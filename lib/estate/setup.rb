# frozen_string_literal: true

module Estate
  module Setup
    module_function

    def call(base)
      ancestors = base.ancestors.map(&:to_s)
      if ancestors.include? 'ActiveRecord::Base'
        require File.join(File.dirname(__FILE__), 'logic', 'active_record', 'setup')
        Estate::Logic::ActiveRecord::Setup.call(base)
      elsif ancestors.include? 'Sequel::Model'
        require File.join(File.dirname(__FILE__), 'logic', 'sequel', 'setup')
        Estate::Logic::Sequel::Setup.call(base)
      else
        require File.join(File.dirname(__FILE__), 'logic', 'plain_ruby_object', 'setup')
        Estate::Logic::PlainRubyObject::Setup.call(base)
      end
    end
  end
end
