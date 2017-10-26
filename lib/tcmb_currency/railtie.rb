require 'tcmb_currency'
require 'rails'
module TcmbCurrency
  class Railtie < Rails::Railtie
    railtie_name :tcmb_currency

    rake_tasks do
      load 'tasks/tcmb_currency.rake'
    end
  end
end
