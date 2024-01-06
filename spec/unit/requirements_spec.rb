# frozen_string_literal: true

RSpec.describe Estate::Requirements do
  describe '.check_requirements' do
    context 'when included in a class with ActiveRecord::Base as ancestor' do
      module ActiveRecord
        class Base
        end
      end

      class ApplicationRecord < ActiveRecord::Base
      end

      it 'does not raise an error' do
        expect { described_class.check_requirements(ApplicationRecord) }.not_to raise_error
      end
    end

    context 'when included in a class without ActiveRecord::Base as ancestor' do
      class NonActiveRecordClass
      end

      it 'raises an error' do
        expect { described_class.check_requirements(NonActiveRecordClass) }.to raise_error(StandardError, 'Estate requires ActiveRecord')
      end
    end

    context 'when included in a module' do
      module SomeModule
      end

      it 'raises an error' do
        expect { described_class.check_requirements(SomeModule) }.to raise_error(StandardError, 'Estate requires ActiveRecord')
      end
    end
  end
end