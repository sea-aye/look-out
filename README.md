# Look Out

In charge of the observation of the code for hazards.

## Installation

Add this line to your application's Gemfile:

```ruby

group :development, :test do
    gem 'look-out', require: false
end

```

And then initialize:

```ruby
# spec/spec_helper.rb

require 'look_out'
LookOut.configure do |config|
  config.api_key = '123'
  config.user = `git config user.name`.chomp
end

```

Add to your `.rspec`

```

--require 'look_out/rspec/look_out_formatter'
--format LookOut::RSpec::LookOutFormatter

# Make sure you have a formatter after this one in your .rspec or there will
# be no output from your spec suite. For example:

--format doc

# or

--format progress

```

#### VCR

If you're using VCR it may raise an exception for an unexpected HTTP request. If
so you can ignore it with:

```

VCR.configure do |config|
  ...
  config.ignore_hosts 'api.sea-aye.com'
  ...
end

```


## Usage

Run specs just like normal!

## Contributing

Bug reports and pull requests are welcome!
