require 'tcmb_currency/version'
require 'money'
require 'open-uri'
require 'multi_json'
require 'active_record'

class Money
  def exchange_to(to_currency, date = nil)
    bank = Bank::TcmbCurrency.new
    bank.exchange_with!(self, to_currency, date)
  end

  module Bank
    class TcmbCurrency < Money::Bank::VariableExchange

      class CrossRate < ActiveRecord::Base

      end

      class CurrencyType < ActiveRecord::Base

      end

      attr_reader :rates

      def exchange_with!(*args)
        from, to_currency, date = args[0], args[1], args[2]
        return from if same_currency?(from.currency, to_currency)
        rate = fetch_rate!(from.currency, to_currency, date)
        unless rate
          raise UnknownRate, "No conversion rate known for '#{from.currency.iso_code}' -> '#{to_currency}'"
        end
        _to_currency_ = Currency.wrap(to_currency)
        fractional = BigDecimal.new(from.fractional.to_s) / (BigDecimal.new(from.currency.subunit_to_unit.to_s) / BigDecimal.new(_to_currency_.subunit_to_unit.to_s))
        ex = (fractional * BigDecimal.new(rate.to_s)).to_f
        ex = if block_given?
               yield ex
             elsif @rounding_method
               @rounding_method.call(ex)
             else
               ex.to_s.to_i
             end
        Money.new(ex, _to_currency_)
      end

      private

      def fetch_rate!(from, to, date)
        from, to = Money::Currency.wrap(from), Money::Currency.wrap(to)
        from_rate = 1.0
        to_rate = 1.0
        if date.nil?
          from_rate = Money::Bank::TcmbCurrency::CrossRate.where(code: from.to_s).last.rate.to_f unless from.to_s == 'USD'
          to_rate = Money::Bank::TcmbCurrency::CrossRate.where(code: to.to_s).last.rate.to_f unless to.to_s == 'USD'
        else
          if Money::Bank::TcmbCurrency::CrossRate.where(date: date).present?
            from_rate = Money::Bank::TcmbCurrency::CrossRate.where(code: from.to_s, date: date).last.rate.to_f unless from.to_s == 'USD'
            to_rate = Money::Bank::TcmbCurrency::CrossRate.where(code: to.to_s, date: date).last.rate.to_f unless to.to_s == 'USD'
          else
            raise 'There is no record in that date.'
          end
        end
        to_rate/from_rate
      end
    end
  end
end

