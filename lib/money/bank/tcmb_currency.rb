require "tcmb_currency/version"
require 'money'
require 'open-uri'
require 'multi_json'
require "active_record"

class Money
  def exchange_to( to_currency, date = Time.now.to_date)
    other_currency = Currency.wrap(to_currency)
    bank = Bank::TcmbCurrency.new
    bank.exchange_with(self,to_currency,date)
  end


  module Bank
    class TcmbCurrency < Money::Bank::VariableExchange
    	class CrossRate < ActiveRecord::Base
			attr_accessible :code, :rate, :date
	 	end  
      SERVICE_HOST = "whispering-springs-5160.herokuapp.com"
      SERVICE_PATH = "/currencies"

      attr_reader :rates

     
      def flush_rates
        @mutex.synchronize{
          @rates = {}
        }
      end


      def flush_rate(from, to, date)
        key = rate_key_for(from, to)
        @mutex.synchronize{
          @rates.delete(key)
        }
      end

      def exchange_with(*args)
        from , to_currency , date = args[0], args[1], args[2]
        return from if same_currency?(from.currency, to_currency)
        
        rate = get_rate(from.currency, to_currency, date)
        unless rate
          raise UnknownRate, "No conversion rate known for '#{from.currency.iso_code}' -> '#{to_currency}'"
        end
        _to_currency_  = Currency.wrap(to_currency)

        fractional = BigDecimal.new(from.fractional.to_s) / (BigDecimal.new(from.currency.subunit_to_unit.to_s) / BigDecimal.new(_to_currency_.subunit_to_unit.to_s))

        ex = fractional * BigDecimal.new(rate.to_s)
        ex = ex.to_f
        ex = if block_given?
               yield ex
             elsif @rounding_method
               @rounding_method.call(ex)
             else
               ex.to_s.to_i
             end
        Money.new(ex, _to_currency_)
      end

      def get_rate(from, to, date)
        @mutex.synchronize{
          @rates[rate_key_for(from, to, date)] ||= fetch_rate(from, to, date)
        }
      end

      private

    
      def fetch_rate(from, to, date)
        from, to = Currency.wrap(from), Currency.wrap(to)
        f = CrossRate.where(code: from.to_s, date: date).last
        t = CrossRate.where(code: to.to_s, date: date).last
        return rate = t.rate.to_f/f.rate.to_f      
      end
      
      def rate_key_for(from, to, date)
        "#{Currency.wrap(from).iso_code}_TO_#{Currency.wrap(to).iso_code}_AT_#{date}".upcase
      end
    end
  end
end

