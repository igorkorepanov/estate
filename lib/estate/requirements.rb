# frozen_string_literal: true

module Estate
  module Requirements
    def check_requirements(base)
      ancestors = base.ancestors.map(&:to_s)

      unless ancestors.include?('Sequel::Model') || ancestors.include?('ActiveRecord::Base')
        raise(StandardError, 'Estate requires ActiveRecord')
      end
    end

    module_function :check_requirements
  end
end
