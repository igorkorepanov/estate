# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Estate works with multiple state machines' do
  let(:model_class) do
    class DummyModel < ActiveRecord::Base
      include Estate

      estate do
        state :state1
        state :state2

        transition from: :state1, to: :state2
      end
    end
    DummyModel
  end

  let(:another_model_class) do
    class AnotherDummyModel < ActiveRecord::Base
      include Estate

      estate do
        state :state3
        state :state4

        transition from: :state3, to: :state4
      end
    end
    AnotherDummyModel
  end

  it 'creates two state machines' do
    expect(model_class.create(state: :state1)).to be_valid
    expect(Estate::StateMachine.state_machines.size).to eq 1
    expect(another_model_class.create(state: :state3)).to be_valid
    expect(Estate::StateMachine.state_machines.size).to eq 2
  end
end
