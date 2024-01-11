# frozen_string_literal: true

module Estate
  module Requirements
    def check_requirements(base)
      ancestors = base.ancestors.map(&:to_s)

      raise(StandardError, 'Estate requires ActiveRecord') unless ancestors.include?('ActiveRecord::Base')
    end

    module_function :check_requirements
  end
end
