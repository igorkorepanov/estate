# frozen_string_literal: true

RSpec.describe Estate do
  let(:class_with_estate) do
    Class.new do
      include Estate
    end
  end

  describe 'self.included' do
    it 'extends the base class with ClassMethods' do
      expect(class_with_estate.singleton_class.included_modules).to include(Estate::ClassMethods)
    end
  end

  describe 'ClassMethods' do
    describe '.estate' do
      before { allow(Estate::Configuration).to receive(:init_config) }

      it 'configures estate with default values' do
        expect { |b| class_with_estate.estate(&b) }.to yield_control
      end

      it 'sets up callbacks using Estate::ActiveRecord' do
        allow(Estate::Setup).to receive(:call)
        class_with_estate.estate
        expect(Estate::Setup).to have_received(:call).with(class_with_estate)
      end

      it 'configures estate with custom values' do
        custom_column_name = :custom_name
        empty_allow_initial_state = !Estate::Configuration::Defaults::ALLOW_EMPTY_INITIAL_STATE
        raise_on_error = !Estate::Configuration::Defaults::RAISE_ON_ERROR
        expect do |b|
          class_with_estate.estate(column: custom_column_name, empty_initial_state: empty_allow_initial_state,
                                   raise_on_error: raise_on_error, &b)
        end.to yield_control
      end

      it 'does not rise an error without a block' do
        expect { class_with_estate.estate }.not_to raise_error
      end
    end

    describe '.state' do
      let(:state) { :state }

      before { allow(Estate::StateMachine).to receive(:state_exists?).and_return(state_exists_condition) }

      context 'with existing state' do
        let(:state_exists_condition) { true }

        it 'raises an error' do
          expect { class_with_estate.state(state) }.to raise_error(StandardError, "state `:#{state}` is already defined")
        end
      end

      context 'without existing state' do
        let(:state_exists_condition) { false }

        before { allow(Estate::StateMachine).to receive(:register_state) }

        it 'can define new state' do
          class_with_estate.state(state)
          expect(Estate::StateMachine).to have_received(:register_state).with(nil, state) # TODO: replace anonymous class (Class.new)
        end
      end
    end

    describe '.transition' do
      let(:from_state) { :start }
      let(:to_state) { :end }

      before do
        allow(Estate::StateMachine).to receive(:state_exists?).with(nil, from_state).and_return(from_state_exists_condition)
      end

      context 'without existing `from` state' do
        let(:from_state_exists_condition) { false }

        it 'raises an error' do
          expect { class_with_estate.transition(from: from_state, to: to_state) }.to raise_error(StandardError, "state `#{from_state}` is not defined")
        end
      end

      context 'with existing from state' do
        let(:from_state_exists_condition) { true }
        let(:to_state_exists_condition) { false }

        before do
          allow(Estate::StateMachine).to receive(:state_exists?).with(nil, to_state).and_return(to_state_exists_condition)
        end

        context 'without existing `to` state' do
          it 'raises an error' do
            expect { class_with_estate.transition(from: from_state, to: to_state) }.to raise_error(StandardError, "state `#{to_state}` is not defined")
          end
        end

        context 'with existing `to` state' do
          let(:to_state_exists_condition) { true }
          let(:transition_exists) { true }

          before do
            allow(Estate::StateMachine).to receive(:transition_exists?).with(nil, from_state, to_state).and_return(transition_exists)
          end

          context 'with existing transition' do
            it 'raises an error' do
              expect { class_with_estate.transition(from: from_state, to: to_state) }.to raise_error(StandardError, "`transition from: :#{from_state}, to: :#{to_state}` already defined")
            end
          end

          context 'without existing transition' do
            let(:transition_exists) { false }

            it 'can register transition' do
              allow(Estate::StateMachine).to receive(:register_transition)
              class_with_estate.transition(from: from_state, to: to_state)
              expect(Estate::StateMachine).to have_received(:register_transition).with(nil, from_state, to_state)
            end
          end
        end
      end
    end
  end
end
