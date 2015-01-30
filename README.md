# WisperSubscription

[![Join the chat at https://gitter.im/jdickey/wisper_subscription](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/jdickey/wisper_subscription?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/wisper_subscription.svg)](http://badge.fury.io/rb/wisper_subscription)
[![Code Climate](https://codeclimate.com/github/jdickey/wisper_subscription.png)](https://codeclimate.com/github/jdickey/wisper_subscription)
[ ![Codeship Status for jdickey/wisper_subscription](https://codeship.com/projects/2e3dfaa0-8950-0132-3d83-4e5a44c3ddcb/status?branch=master)](https://codeship.com/projects/59675)
[![security](https://hakiri.io/github/jdickey/wisper_subscription/master.svg)](https://hakiri.io/github/jdickey/wisper_subscription/master)
[![Dependency Status](https://gemnasium.com/jdickey/wisper_subscription.svg)](https://gemnasium.com/jdickey/wisper_subscription)

This Gem contains a class, `WisperSubscription`, which encapsulates an extremly
simple container to record call parameters for messages, and query methods for
whether a defined message was sent. This is a refinement of a class
[originally developed](https://github.com/jdickey/new_poc/blob/c255cbd/spec/support/broadcast_success_tester.rb)
to record results of very specific [Wisper](https://github.com/krisleech/wisper)
broadcast messages to support testing of broadcasters of such messages. While
[restructuring that app](https://github.com/jdickey/new_poc/issues/54), the
existing `BroadcastSuccessTester` was identified as a dependency of the testing
for [*multiple*](https://github.com/jdickey/new_poc/issues/173) to-be-decoupled
classes. Including that test-support class in so many redundant places would have
been an engraved invitation to sync-related bugs (and egregious waste), and so
this `WisperSubscription` class/Gem was created.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wisper_subscription'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wisper_subscription

## Usage

Remember that this was originally developed to support testing Wisper message
broadcast from an object. So you might have an RSpec file (Minitest would be
similar) that had excerpts [similar to](https://github.com/jdickey/new_poc/blob/c255cbd/spec/actions/index_users_spec.rb):

```ruby
describe SomeWisperPublishingClass do
  let(:subscriber) { WisperSubscription.new }
  let(:command_params) do
    # ...
  end
  let(:command) { described_class.new command_params }

  before :each do
    # some setup
    subscriber.define_message :success
    subscriber.define_message :failure
    command.subscribe subscriber
    command.do_something_that_broadcasts_a_success
  end

  it 'was successful' do
    payload = subscriber.payload_for(:success, 0)
    expect(payload.first).to be_a WhatYouExpectOnSuccess # as opposed to nil
  end

  # ...
end
```

You get the idea. If not, open an issue or ask on our
[Gitter channel](https://gitter.im/jdickey/wisper_subscription).

### Methods

#### `initialize`

Parameters: none.

Initialises instance internal state.

#### `define_message(message)`

Parameters:

1. `message` (a Symbol; e.g., `:bangbang`)

Returns: `self`

Defines a *listener method* (e.g., `#bangbang`) to receive events published by a
[Wisper publisher](https://github.com/krisleech/wisper/#publishing) or similar
mechaism. Any parameters a listener method is called with will be retreivaable
by using the `#payload_for` or `#payloads_for` methods (see below).

Defines a query method (e.g., `#bangbang?`) which returns `true` if payloads for
the message have been received; `false` otherwise.

#### `payloads_for(message)`

Parameters:

1. `message` (a Symbol, e.g., `:bangbang`)

Returns: an Array

Returns an Array of all *payloads* received by the listener method corresponding
to the parameter. If no calls to the listener method have been made, *or* if the
listener method has not been defined because `#define_message` has not been
called using that `message`, then an empty Array is returned.

#### `payload_for(message, index = 0)`

Parameters:

1. `message` (a Symbol, e.g., `:bangbang`)
1. `index` (an integer, defaulting to 0)

Returns: an Array or `nil`

Returns an Array containing the *payload* received by the `index`th invocation
of the listener method (zero-based). A *payload* is simply the set of (zero or)
more) parameters sent to the listener method. If no calls to the listener method
have been made, *or* if the listener method has not been defined because
`#define_message` has not been called using that `message`, then this method
returns `nil`. If the listener method *has* been defined but the specified index
is outside the range of received payloads, then returns an empty Array.

## Contributing

1. Fork it ( https://github.com/jdickey/wisper_subscription/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Ensure that your changes are completely covered by *passing* specs, and comply with the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) as enforced by [RuboCop](https://github.com/bbatsov/rubocop). To verify this, run `bundle exec rake`, noting and repairing any lapses in coverage or style violations;
1. Commit your changes (`git commit -a`). Please *do not* use a single-line commit message (`git commit -am "some message"`). A good commit message notes what was changed and why in sufficient detail that a relative newcomer to the code can understand your reasoning and your code;
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request. Describe at some length the rationale for your new feature; your implementation strategy at a higher level than each individual commit message; anything future maintainers should be aware of; and so on. *If this is a modification to existing code, reference the open issue being addressed*.
1. Don't be discouraged if the PR generates a discussion that leads to further refinement of your PR through additional commits. These should *generally* be discussed in comments on the PR itself; discussion in the Gitter room (see below) may also be useful;
1. If you've comments, questions, or just want to talk through your ideas, come hang out in the project's [room on Gitter](https://gitter.im/jdickey/wisper_subscription). Ask away!
