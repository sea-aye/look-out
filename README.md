# Look Out

In charge of the observation of the code for hazards.

## Installation

Add this line to your application's Gemfile:

```ruby

gem 'look-out'

```

And then initialize:

```ruby

LookOut.configure do |config|
  config.api_key = '123'
  config.env = Rails.env
  config.repo = 'sea-aye/pirate'
  config.user = `git config user.name`.chomp
end

```

Add to your 'spec_helper.rb`

```

require 'look_out/rspec/look_out_formatter'

```

Add to your `.rspec`

```

--format LookOut::RSpec::LookOutFormatter

```

## Usage

Run specs just like normal!

## Contributing

Bug reports and pull requests are welcome!
