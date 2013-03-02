require "tcmb_currency/version"
require 'money'
require 'open-uri'
require 'multi_json'

class Money

  def exchange_to( to_currency, date = Time.now.to_date)
    other_currency = Currency.wrap(to_currency)
    bank = Bank::TcmbCurrency.new
    bank.exchange_with(self,to_currency,date)
  end

  module Bank
    class TcmbCurrency < Money::Bank::VariableExchange

      SERVICE_HOST = "whispering-springs-5160.herokuapp.com"
      SERVICE_PATH = "/currencies"

      # @return [Hash] Stores the currently known rates.
      attr_reader :rates

      ##
      # Clears all rates stored in @rates
      #
      # @return [Hash] The empty @rates Hash.
      #
      # @example
      #   @bank = GoogleCurrency.new  #=> <Money::Bank::GoogleCurrency...>
      #   @bank.get_rate(:USD, :EUR)  #=> 0.776337241
      #   @bank.flush_rates           #=> {}
      def flush_rates
        @mutex.synchronize{
          @rates = {}
        }
      end

      ##
      # Clears the specified rate stored in @rates.
      #
      # @param [String, Symbol, Currency] from Currency to convert from (used
      #   for key into @rates).
      # @param [String, Symbol, Currency] to Currency to convert to (used for
      #   key into @rates).
      #
      # @return [Float] The flushed rate.
      #
      # @example
      #   @bank = GoogleCurrency.new    #=> <Money::Bank::GoogleCurrency...>
      #   @bank.get_rate(:USD, :EUR)    #=> 0.776337241
      #   @bank.flush_rate(:USD, :EUR)  #=> 0.776337241
      def flush_rate(from, to, date)
        key = rate_key_for(from, to)
        @mutex.synchronize{
          @rates.delete(key)
        }
      end

      #def exchange_to(*args)
      #  other_currency = args[0]
      #  bank = args[1]
      #  other_currency = Currency.wrap(other_currency)
      #  @bank.exchange_with(self, other_currency, bank)
      #end
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
      ##
      # Returns the requested rate.
      #
      # @param [String, Symbol, Currency] from Currency to convert from
      # @param [String, Symbol, Currency] to Currency to convert to
      #
      # @return [Float] The requested rate.
      #
      # @example
      #   @bank = GoogleCurrency.new  #=> <Money::Bank::GoogleCurrency...>
      #   @bank.get_rate(:USD, :EUR)  #=> 0.776337241
      def get_rate(from, to, date)
        @mutex.synchronize{
          @rates[rate_key_for(from, to, date)] ||= fetch_rate(from, to, date)
        }
      end

      private

      ##
      # Queries for the requested rate and returns it.
      #
      # @param [String, Symbol, Currency] from Currency to convert from
      # @param [String, Symbol, Currency] to Currency to convert to
      #
      # @return [BigDecimal] The requested rate.
      def fetch_rate(from, to, date)
        from, to = Currency.wrap(from), Currency.wrap(to)

        data = build_uri(from, to, date).read
        data = fix_response_json_data(data)


        return data['amount']
      end

      ##
      # Build a URI for the given arguments.
      #
      # @param [Currency] from The currency to convert from.
      # @param [Currency] to The currency to convert to.
      #
      # @return [URI::HTTP]
      def build_uri(from, to, date)

        uri = URI::HTTP.build(
          :host => SERVICE_HOST,
          :path => SERVICE_PATH,
          :query => "cash=1&from=#{from.iso_code}&to=#{to.iso_code}&date=#{date}"
        )
        #&date=#{hist}
      end

      ##
      # Takes the invalid JSON returned by Google and fixes it.
      #
      # @param [String] data The JSON string to fix.
      #
      # @return [Hash]
      def fix_response_json_data(data)
        data.gsub!(/from:/, '"from":')
        data.gsub!(/from_name:/, '"from_name":')
        data.gsub!(/to:/, '"to":')
        data.gsub!(/to_name:/, '"to_name":')
		    data.gsub!(/amount:/, '"amount":')
        data.gsub!(Regexp.new("(\\\\x..|\\\\240)"), '')

        MultiJson.decode(data)
      end
      def rate_key_for(from, to, date)
        "#{Currency.wrap(from).iso_code}_TO_#{Currency.wrap(to).iso_code}_AT_#{date}".upcase
      end
    end
  end
end


