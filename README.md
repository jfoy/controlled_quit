# ControlledQuit

Gem to allow a controlled quit from a command-line application.

## Installation

Add this line to your application's Gemfile:

    gem 'controlled_quit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install controlled_quit

## Usage

ControlledQuit.protect do |quitter|
  units_of_work.each do |unit|
    unit.do_work_and_serialize
    quitter.quit_if_requested
  end
end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
