# frozen_string_literal: true

module Estate
  module Core
    module_function

    def setup(base)
      if 'ActiveRecord::Base'.in? base.ancestors.map(&:to_s)
        require File.join(File.dirname(__FILE__), 'orm', 'active_record')
        require File.join(File.dirname(__FILE__), 'new_core', 'active_record')
        Estate::Orm::ActiveRecord.setup(base)
      else
        require File.join(File.dirname(__FILE__), 'orm', 'sequel')
        require File.join(File.dirname(__FILE__), 'new_core', 'sequel')
        Estate::Orm::Sequel.setup(base)
      end
    end
  end
end
