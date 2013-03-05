require "tcmb_currency/version"
require "active_support/dependencies"

module TcmbCurrency
  require 'tcmb_currency/railtie' if defined?(Rails)
end