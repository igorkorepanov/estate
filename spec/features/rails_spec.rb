# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Estate works with Rails' do
  context 'with allowed empty initial state' do
    before do
      class DummyModel < ActiveRecord::Base
        include Estate

        estate empty_initial_state: true do
          state :state1
          state :state2
          state :state3

          transition from: :state1, to: :state2
          transition from: :state2, to: :state3
          transition from: :state3, to: :state1
        end
      end
    end

    it 'creates a model' do
      model = DummyModel.create
      expect(model.state).to eq nil
    end
  end

  context 'with disallowed empty initial state' do
    before do
      class DummyModel < ActiveRecord::Base
        include Estate

        estate empty_initial_state: false do
          state :state1
          state :state2
          state :state3

          transition from: :state1, to: :state2
          transition from: :state2, to: :state3
          transition from: :state3, to: :state1
        end
      end
    end

    it 'does not create model' do
      model = DummyModel.create
      expect(model).not_to be_valid
      expect(model.errors.messages[:base]).to eq ['empty `state` is not allowed']
    end

    it 'creates a model' do
      model = DummyModel.create(state: :state1)
      expect(model.state).to eq 'state1'
    end

    it 'does not allow a transition to empty state' do
      model = DummyModel.create(state: :state1)
      model.update(state: nil)
      expect(model).not_to be_valid
      expect(model.errors.messages[:base]).to eq ['transition to empty state is not allowed']
    end

    it 'does not allow a transition to non-existent state' do
      model = DummyModel.create(state: :state1)
      model.update(state: :non_existent_state)
      expect(model).not_to be_valid
      expect(model.errors.messages[:base]).to eq ['state `non_existent_state` is not defined']
    end

    it 'does not allow a transition to a state that cannot be transitioned to' do
      model = DummyModel.create(state: :state1)
      model.update(state: :state3)
      expect(model).not_to be_valid
      expect(model.errors.messages[:state]).to eq [{ message: 'transition from `state1` to `state3` is not allowed' }]
    end
  end
end
