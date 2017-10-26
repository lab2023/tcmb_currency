require 'rails/generators/migration'
require 'rails/generators/active_record'

module TcmbCurrency
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    namespace 'tcmb_currency:migration'

    source_root File.join(File.dirname(__FILE__), 'templates')

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def create_migration_file
      migration_template 'typemigration.rb', 'db/migrate/create_currency_types.rb'
      migration_template 'migration.rb', 'db/migrate/create_cross_rates_table.rb'
    rescue StandardError => e
      raise e
    end
  end
end
