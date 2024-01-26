# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Estate works with Sequel' do
  let(:model_class) do # TODO: safe define class
    class DModel < Sequel::Model
      include Estate

      plugin :dirty

      estate do
        state :state1
        state :state2
        state :state3

        transition from: :state1, to: :state2
      end
    end

    DModel
  end

  it 'creates a model' do
    model = model_class.new(state: :state1)
    expect(model).to be_valid
    expect(model.state).to eq 'state1'
  end

  it 'makes transition from one state to another' do
    model = model_class.create(state: :state1)
    model.update(state: :state2)
    expect(model).to be_valid
    expect(model.state).to eq 'state2'
  end

  it 'does not create model with empty state' do
    model = model_class.new
    expect(model).not_to be_valid
    expect(model.errors[:base]).to eq ['empty `state` is not allowed']
  end

  it 'does not allow a transition to empty state' do
    model = model_class.create(state: :state1)
    model.set(state: nil)
    expect(model).not_to be_valid
    expect(model.errors[:base]).to eq ['transition to empty state is not allowed']
  end

  it 'does not allow a transition to non-existent state' do
    model = model_class.create(state: :state1)
    model.set(state: :non_existent_state)
    expect(model).not_to be_valid
    expect(model.errors[:base]).to eq ['state `non_existent_state` is not defined']
  end

  it 'does not allow a transition to a state that cannot be transitioned to' do
    model = model_class.create(state: :state1)
    model.set(state: :state3)
    expect(model).not_to be_valid
    expect(model.errors[:state]).to eq ['transition from `state1` to `state3` is not allowed']
  end
end
