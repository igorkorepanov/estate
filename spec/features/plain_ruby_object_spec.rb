# frozen_string_literal: true

# require 'rails_helper'

RSpec.describe 'Estate works with plain ruby objects' do
  let(:model_class) do
    class PlainDummyModel
      include Estate

      estate do
        state :state1
        state :state2
        state :state3

        transition from: :state1, to: :state2
      end

      attr_accessor :state
    end
    PlainDummyModel
  end

  it 'creates a model' do
    model = model_class.new
    model.state = :state1
    expect(model.state).to eq :state1
  end

  it 'makes transition from one state to another' do
    model = model_class.new
    model.state = 'state1'
    expect { model.state = 'state2' }.not_to raise_error
  end

  it 'does not allow a transition to empty state' do
    model = model_class.new
    model.state = :state1
    expect { model.state = nil }.to raise_error(StandardError, 'transition to empty state is not allowed')
  end

  it 'does not allow a transition to non-existent state' do
    model = model_class.new
    expect { model.state = :non_existent_state }.to raise_error(StandardError, 'state `non_existent_state` is not defined')
  end

  it 'does not allow a transition to a state that cannot be transitioned to' do
    model = model_class.new
    model.state = :state1
    expect { model.state = :state3 }.to raise_error(StandardError, 'state: transition from `state1` to `state3` is not allowed')
  end
end
