class CreateCrossRatesTable < ActiveRecord::Migration[5.0]
  def self.up
    create_table :cross_rates do |t|
      t.string :code
      t.string :name
      t.string :rate
      t.date :date
      t.timestamps
    end
    add_index :cross_rates, :code
  end

  def self.down
    drop_table :cross_rates
  end
end
