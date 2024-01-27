# frozen_string_literal: true

RSpec.describe Estate::Requirements do
  describe '.check_requirements' do
    context 'when included in a class with ActiveRecord::Base as ancestor' do
      it 'does not raise an error' do
        active_record_stub = stub_const('ActiveRecord::Base', Class.new)
        stub_const('ARClass', Class.new(active_record_stub))

        expect { described_class.check_requirements(ARClass) }.not_to raise_error
      end
    end

    context 'when included in a class with Sequel::Model as ancestor' do
      it 'does not raise an error' do
        active_record_stub = stub_const('Sequel::Model', Class.new)
        stub_const('SequelClass', Class.new(active_record_stub))

        expect { described_class.check_requirements(SequelClass) }.not_to raise_error
      end
    end

    context 'when included in a class without ActiveRecord::Base as ancestor' do
      it 'raises an error' do
        stub_const('NonActiveRecordClass', Class.new)

        expect { described_class.check_requirements(NonActiveRecordClass) }.to raise_error(StandardError, 'Estate requires ActiveRecord or Sequel')
      end
    end

    context 'when included in a module' do
      it 'raises an error' do
        stub_const('SomeModule', Module.new)

        expect { described_class.check_requirements(SomeModule) }.to raise_error(StandardError, 'Estate requires ActiveRecord or Sequel')
      end
    end
  end
end
