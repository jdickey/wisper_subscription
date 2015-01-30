
require 'wisper_subscription/version'

require 'awesome_print'

# Collects and reports on messages sent to an instance.
class WisperSubscription
  def initialize
    @internals = {}
    @empty_payload = []
    @query_pattern = /^.*\?$/
  end

  def define_message(message)
    @message = message
    add_internals_entry
    add_query_method
    add_listener_method
    self
  end

  def payload_for(message, index = 0)
    return nil unless @internals.key? message
    payloads_for(message)[index]
  end

  def payloads_for(message)
    return empty_payload unless @internals.key? message
    @internals[message]
  end

  def method_missing(method_sym, *arguments, &block)
    return false if method_sym.to_s =~ query_pattern
    super
  end

  def respond_to?(symbol, include_all = false)
    return true if symbol.to_s =~ query_pattern
    super
  end

  private

  attr_reader :empty_payload, :query_pattern

  def add_internals_entry
    @internals[@message.to_sym] = []
    self
  end

  def add_query_method
    message = @message
    define_singleton_method "#{@message}?".to_sym do
      !@internals[message].to_a.empty?
    end
    self
  end

  def add_listener_method
    message = @message
    define_singleton_method @message.to_sym do |*params|
      @internals[message].push params
      self
    end
    self
  end
end
