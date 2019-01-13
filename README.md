# Look Out

In charge of the observation of the code for hazards.

## Installation

Add this line to your application's Gemfile:

```ruby

group :development, :test do
  gem 'look-out'
end

```

And then initialize:

```ruby

# In rails this would be config/initializers/look_out.rb

LookOut.configure do |config|
  config.api_key = '123'
  config.user = `git config user.name`.chomp
end

```

Add to your `.rspec`

```

--require 'look_out/rspec/look_out_formatter'
--format LookOut::RSpec::LookOutFormatter

```

## Usage

Run specs just like normal!

## Contributing

Bug reports and pull requests are welcome!
