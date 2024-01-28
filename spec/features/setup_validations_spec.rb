# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'setup validations' do
  context 'with invalid "estate" argument' do
    let(:model_class) do
      stub_const('DummyModel', Class.new(ActiveRecord::Base) do
        include Estate

        estate do
          state 1
        end
      end)
    end

    it 'raises an error' do
      expect { model_class.create(state: :state1) }.to raise_error(StandardError, 'state must be a Symbol or a String')
    end
  end

  context 'with invalid "from" argument' do
    let(:model_class) do
      stub_const('DummyModel', Class.new(ActiveRecord::Base) do
        include Estate

        estate do
          state :state1

          transition from: 1
        end
      end)
    end

    it 'raises an error' do
      expect { model_class.create(state: :state1) }.to raise_error(StandardError, 'argument `from` must be a Symbol or a String')
    end
  end

  context 'with invalid "to" argument' do
    let(:model_class) do
      stub_const('DummyModel', Class.new(ActiveRecord::Base) do
        include Estate

        estate do
          state :state1

          transition from: :state1, to: 1
        end
      end)
    end

    it 'raises an error' do
      expect { model_class.create(state: :state1) }.to raise_error(StandardError, 'argument `to` must be a Symbol or a String')
    end
  end
end
