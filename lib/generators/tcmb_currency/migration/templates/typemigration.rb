class CreateCurrencyTypes < ActiveRecord::Migration
  def self.up
    create_table :currency_types do |t|
      t.string :currency

      t.timestamps
    end

    currencies = ['USD', 'EUR', 'GBP', 'TRY', 'CAD', 'XDR', 'DKK', 'SEK', 'CHF', 'NOK', 'JPY', 'SAR', 'KWD', 'AUD', 'RUB', 'RON', 'PKR', 'IRR', 'CNY', 'BGN']
    currencies.each do |c|
      CURRENCY_TYPE.create(currency: c.to_s)
    end
  end

  def self.down
    drop_table :currency_types
  end

end