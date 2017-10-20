[![Code Climate](https://codeclimate.com/github/lab2023/tcmb_currency.png)](https://codeclimate.com/github/lab2023/tcmb_currency)
[![Dependency Status](https://gemnasium.com/lab2023/tcmb_currency.png)](https://gemnasium.com/lab2023/tcmb_currency)
# TcmbCurrency

Tcmb Currencies for [Money Gem](https://github.com/RubyMoney/money)

it based on [money gem](https://github.com/RubyMoney/money), [money-rails Gem](https://github.com/RubyMoney/money-rails), and adapted from [google-currency gem](https://github.com/RubyMoney/google_currency)

## Installation

Add this line to your application's Gemfile:
	
	gem 'money-rails'

    ### For rails 4.x

    gem 'tcmb_currency', '~> 0.5.0', :git => 'git://github.com/lab2023/tcmb_currency.git'


And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tcmb_currency
    
## Requirements

Before generating your application, you will need:

* The Ruby language (version 1.9.3)
* Rails 3.2

## Usage
	
After the installing gems run:

	$ rails g tcmb_currency:initializer
	$ rails g tcmb_currency:migration
	$ rake db:migrate

at last add to daily cron tasks this rake 
	
	$ rake tcmb_currency:insert_from_tcmb

And you can use it as

	Money.new(1000,"USD").exchange_to(:EUR)
	Money.new(1000,"USD").exchange_to(:EUR, "2013-03-02")
	
If there is no record for searches with history, you will get `There is no record in that date` error.
	
## Contributing

Once you've made your great commits:

1. Fork Gem
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create a Pull Request from your branch
5. That's it!

## Credits

![lab2023](http://lab2023.com/assets/images/named-logo.png)

This gem is maintained and funded by [lab2023 - information technologies](http://lab2023.com/)

Thank you to all the [contributors!](../../graphs/contributors)

The names and logos for lab2023 are trademarks of lab2023, inc.

## License

[MIT License](http://www.opensource.org/licenses/mit-license)

Copyright 2014 lab2023 - information technologies

