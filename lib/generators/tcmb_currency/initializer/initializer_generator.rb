require 'rails/generators/migration'
require 'rails/generators/active_record'

module TcmbCurrency
  class InitializerGenerator < ::Rails::Generators::Base
    source_root File.join(File.dirname(__FILE__), 'templates')

    desc 'Creates a sample Tcmb_Currency initializer.'

    def copy_initializer
      copy_file 'money.rb', 'config/initializers/money.rb'
    end
  end
end
