
require 'spec_helper'

describe WisperSubscription do
  let(:obj) { described_class.new }
  let(:message) { :foo }

  it 'has a version number' do
    expect(WisperSubscription::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'can be called without parameters' do
      expect { described_class.new }.not_to raise_error
    end
  end # describe '#initialize'

  describe '#define_message' do
    it 'can be called with a symbol as the single paremter' do
      expect { obj.define_message message }.not_to raise_error
    end

    it 'requires a single parameter (only)' do
      expect(obj.method(:define_message).arity).to eq 1
    end

    it 'adds a new entry to the internal store' do
      expect(obj.instance_variable_get(:@internals)).to be_empty
      obj.define_message message
      internals = obj.instance_variable_get :@internals
      expect(internals.keys.length).to eq 1
    end

    describe 'adds a new' do
      before :each do
        obj.define_message message
        @internals = obj.instance_variable_get :@internals
      end

      describe 'entry to the internal store that is' do
        it 'Array-like' do
          # Reminder: Array#to_ary is the IMPLICIT convert-to-Array method
          expect(@internals[message]).to respond_to :to_ary
        end

        it 'initially empty' do
          expect(@internals[message]).to be_empty
        end

        it 'keyed to the parameter-specified message' do
          expect(@internals.keys).to include message
        end
      end # describe 'entry to the internal store that is'

      it 'public query method to the class instance' do
        query = "#{message}?".to_sym
        expect { obj.method query }.not_to raise_error
        method = obj.method query
        expect(method.arity).to eq 0
      end

      it 'message-responder method to the class instance' do
        expect { obj.method message }.not_to raise_error
        method = obj.method message
        expect(method.arity).to eq(-1)
      end
    end # describe 'adds a new'
  end # describe '#define_message'
end
