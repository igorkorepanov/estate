# frozen_string_literal: true

module Estate
  module Requirements
    def check_requirements(base)
      ancestors = base.ancestors.map(&:to_s)

      unless 'Sequel::Model'.in?(ancestors) || 'ActiveRecord::Base'.in?(ancestors)
        raise(StandardError, 'Estate requires ActiveRecord or Sequel')
      end
    end

    module_function :check_requirements
  end
end
