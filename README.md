[![Code Climate](https://codeclimate.com/github/lab2023/tcmb_currency.png)](https://codeclimate.com/github/lab2023/tcmb_currency)
[![Dependency Status](https://gemnasium.com/lab2023/tcmb_currency.png)](https://gemnasium.com/lab2023/tcmb_currency)
# TcmbCurrency

Tcmb Currencies for [Money Gem](https://github.com/RubyMoney/money)

it based on [money gem](https://github.com/RubyMoney/money), [money-rails Gem](https://github.com/RubyMoney/money-rails), and adapted from [google-currency gem](https://github.com/RubyMoney/google_currency)

## Installation

Add this line to your application's Gemfile:
	
	gem 'money-rails'
    gem 'tcmb_currency'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tcmb_currency

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


	

