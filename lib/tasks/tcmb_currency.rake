namespace :tcmb_currency do
 desc 'insert tcmb_currency rates to db'
  task :insert => [:environment] do
   require 'open-uri'
   require 'multi_json'
   
   SERVICE_HOST = "whispering-springs-5160.herokuapp.com"
   SERVICE_PATH = "/currencies"

   uri = URI::HTTP.build(
   	:host => SERVICE_HOST, 
   	:path => SERVICE_PATH,
   	:query => "date=#{Time.now.to_date}" )
   
   data = uri.read
   data = MultiJson.decode(data)
   data.each do |d|
   	rate = d['crossrateusd'].to_f
   	rate = rate.round(4)
    Money::Bank::TcmbCurrency::CrossRate.create!({code: d['code'], rate: rate, date: Time.now.to_date })
   end
  end
end