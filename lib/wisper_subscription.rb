
require 'wisper_subscription/version'

# Collects and reports on messages sent to an instance.
class WisperSubscription
  def initialize
    @internals = {}
    @empty_payload = []
  end

  def define_message(message)
    @message = message
    add_internals_entry
    add_query_method
    add_responder_method
    self
  end

  def payload_for(message)
    return empty_payload unless @internals.key? message
    @internals[message]
  end

  private

  attr_reader :empty_payload

  def add_internals_entry
    @internals[@message.to_sym] = []
    self
  end

  def add_query_method
    message = @message
    define_singleton_method "#{@message}?".to_sym do
      @internals[message].to_a.empty?
    end
    self
  end

  def add_responder_method
    message = @message
    define_singleton_method @message.to_sym do |*params|
      @internals[message].push params
      self
    end
    self
  end
end
