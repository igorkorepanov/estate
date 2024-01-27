# frozen_string_literal: true

module Estate
  module Core
    module_function

    def setup(base)
      if 'ActiveRecord::Base'.in? base.ancestors.map(&:to_s)
        require File.join(File.dirname(__FILE__), 'db', 'active_record')
        Estate::Db::ActiveRecord.setup_callbacks(base)
      else
        require File.join(File.dirname(__FILE__), 'db', 'sequel')
        Estate::Db::Sequel.setup_callbacks(base)
      end
    end
  end
end
