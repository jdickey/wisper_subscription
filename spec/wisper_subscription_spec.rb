
require 'spec_helper'

describe WisperSubscription do
  let(:obj) { described_class.new }
  let(:message) { :foo }
  let(:other_message) { :bar }

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

  describe '#payload_for' do
    describe 'accepts two parameters, with' do
      let(:method) { described_class.new.method :payload_for }

      it 'the first, :message, being required' do
        expect(method.parameters.count).to eq 2
        expect(method.parameters.first).to eq [:req, :message]
      end

      it 'the second, :index, being optional' do
        expect(method.parameters.last).to eq [:opt, :index]
      end
    end # describe 'accepts two parameters, with'

    describe 'returns nil when' do
      it 'no messages have been defined' do
        expect(obj.payload_for message).to eq nil
      end

      it 'the specified message has been defined but not received' do
        obj.define_message other_message
        expect(obj.payload_for message).to eq nil
      end

      it 'the specified index exceeds the range of received messages' do
        obj.define_message message
        obj.send message, 'foo'
        expect(obj.payload_for message, 52).to eq nil
      end
    end # describe 'returns nil when'

    context 'when the message was received and the index is in range' do
      before :each do
        obj.define_message message
      end

      it 'returns an Array containing the specified payload when supplied' do
        obj.send message, 'foo'
        expect(obj.payload_for message, 0).to eq ['foo']
      end

      it 'returns an empty Array if no payload for the message was specified' do
        obj.send message
        expect(obj.payload_for message, 0).to eq []
      end
    end # context 'when the message was received and the index is in range'

    fit 'uses zero as a default for the second (index) parameter' do
      obj.define_message message
      [:foo, :bar, :baz].each { |payload| obj.send message, payload }
      expect(obj.payload_for message).to eq [:foo]
    end
  end # describe '#payload_for'

  describe '#payloads_for' do
    it 'takes a single parameter' do
      method = obj.method :payloads_for
      expect(method.arity).to eq 1
    end

    describe 'returns a no-payloads-received indicator when' do
      let(:none_received) { [] }

      after :each do
        expect(obj.payloads_for message).to eq none_received
      end

      it 'no messages have been defined' do
      end

      it 'other messages have been defined but this message has not been' do
        obj.define_message other_message
      end

      it 'the specified message has been defined but not received' do
        obj.define_message message
      end
    end # describe 'returns a no-payloads-received indicator when'

    describe 'returns the payload(s) received for the specified message when' do
      before :each do
        obj.define_message message
      end

      it 'a single payload for that message has been stored' do
        expected = %w(This is a test.)
        obj.send message, *expected
        payloads = obj.payloads_for message
        expect(payloads).to be_an Array
        expect(payloads.count).to eq 1 # One payload has been delivered
        payload = payloads.first
        expect(payload.count).to eq expected.count
        expect(payload).to eq expected
      end

      it 'multiple payloads for that message have been stored' do
        obj.send message, 'one'
        obj.send message, 'two', 'three'
        payloads = obj.payloads_for message
        expect(payloads.count).to eq 2 # Two payloads delivered
        expect(payloads.first).to eq ['one']
        expect(payloads.last).to eq %w(two three)
      end
    end # describe 'returns the payload(s) received for the ... message when'
  end # describe '#payloads_for'

  describe '#respond_to?' do
    it 'returns true for any query method' do
      expect(obj).to respond_to :is_that_right?
      expect(obj).to respond_to :you_dont_say?
      expect(obj).to respond_to :all_tone_here?
    end

    it 'returns false for any other undefined method' do
      expect(obj).not_to respond_to :taunts
      expect(obj).not_to respond_to :threats
      expect(obj).not_to respond_to :anything
    end
  end # describe '#respond_to?'

  describe '.method_missing' do
    it 'causes an unknown query method to return false' do
      expect(obj).not_to be_success
      expect(obj).not_to be_real
      expect(obj).not_to be_anything_in_particular
    end

    it 'raises a NoMethodError for any other undefined method' do
      message = Regexp.new 'undefined method `bogus\' for'
      expect { obj.bogus }.to raise_error NoMethodError, message
    end
  end # describe '.method_missing'
end
