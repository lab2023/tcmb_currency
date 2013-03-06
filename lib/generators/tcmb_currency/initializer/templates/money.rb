# encoding : utf-8
require 'money'
require 'money/bank/tcmb_currency'
require 'json'
MultiJson.engine = :json_gem
Money.default_bank = Money::Bank::TcmbCurrency.new
CROSS_RATE = Money::Bank::TcmbCurrency::CrossRate
CURRENCY_TYPE = Money::Bank::TcmbCurrency::CurrencyType