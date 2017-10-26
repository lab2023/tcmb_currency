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
        from = args[0]
        to_currency = args[1]
        date = args[2]
        return from if same_currency?(from.currency, to_currency)
        rate = fetch_rate!(from.currency, to_currency, date)
        unless rate
          raise UnknownRate, "No conversion rate known for
                '#{from.currency.iso_code}' -> '#{to_currency}'"
        end
        wrap_to_currency_ = Currency.wrap(to_currency)
        fractional = get_fractional(from, wrap_to_currency_)
        ex = (fractional * BigDecimal.new(rate.to_s)).to_f
        ex = if block_given?
               yield ex
             elsif @rounding_method
               @rounding_method.call(ex)
             else
               ex.to_s.to_i
             end
        Money.new(ex, wrap_to_currency_)
      end

      private

      def get_fractional(from, to_currency)
        bd_from_fractional = BigDecimal.new(from.fractional.to_s)
        bd_from_currency = BigDecimal.new(from.currency.subunit_to_unit.to_s)
        bd_to_currency = BigDecimal.new(to_currency.subunit_to_unit.to_s)
        bd_from_fractional / (bd_from_currency / bd_to_currency)
      end

      def fetch_rate!(from, to, date)
        from_to_s = Money::Currency.wrap(from).to_s
        to_to_s = Money::Currency.wrap(to).to_s
        from_rate = 1.0
        to_rate = 1.0
        froms = Money::Bank::TcmbCurrency::CrossRate.where(code: from_to_s)
        tos = Money::Bank::TcmbCurrency::CrossRate.where(code: to_to_s)
        if date.nil?
          from_rate = froms.last.rate.to_f unless from_to_s == 'USD'
          to_rate = tos.last.rate.to_f unless to_to_s == 'USD'
        else
          unless Money::Bank::TcmbCurrency::CrossRate.where(date: date).present?
            raise 'There is no record in that date.'
          end
          from_rate = froms.where(date: date).last.rate.to_f unless from_to_s == 'USD'
          to_rate = tos.where(date: date).last.rate.to_f unless to_to_s == 'USD'
        end
        to_rate / from_rate
      end
    end
  end
end
