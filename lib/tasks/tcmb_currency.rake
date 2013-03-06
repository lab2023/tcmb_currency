namespace :tcmb_currency do
 desc 'insert tcmb_currency rates to db'
  task :insert_from_tcmb => [:environment] do
    require "nokogiri"
    require "open-uri"
    @doc = Nokogiri::XML(open('http://www.tcmb.gov.tr/kurlar/today.xml'))
    @code = Array.new
    @doc.css("Currency").each do |response_node|
      @code.push(response_node["Kod"])
    end
    @data = @doc.xpath('//Currency')
    @currency = Hash.new
    i=0
    while i<@code.length
      cross = ""
      if @data[i].css('CrossRateUSD').children.to_s == ""
        cross = 1.to_f/@data[i].css('CrossRateOther').children.to_s.to_f
      else
        cross = @data[i].css('CrossRateUSD').children.to_s
      end
      cross = cross.to_f.round(4)
      if cross.to_s != "Infinity"
        @currency = {
            :code => @code[i],
            :name => @data[i].css('CurrencyName').children.to_s.encode('UTF-8'),
            :rate => cross.to_s,
            :date => Time.now.to_date
        }
        Money::Bank::TcmbCurrency::CrossRate.create!(@currency)
      end
      i += 1
    end
    @currency = {
        :code => "TRY",
        :name => "Turkish Lira",
        :rate => @data[0].css('ForexBuying').children.to_s.to_f.round(4),
        :date => Time.now.to_date
    }
    Money::Bank::TcmbCurrency::CrossRate.create(@currency)
  end
end