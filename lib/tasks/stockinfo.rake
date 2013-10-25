namespace :stockinfo do

	desc "Update the stock info through an API call"
	task :pull => :environment do
		url = "https://s3.amazonaws.com/quandl-static-content/Ticker+CSV%27s/stockinfo.csv"
		data_hash = SmarterCSV.process(open(url), options={:user_provided_headers => [:ticker_sign,:quandl_code,:proper_name,:industry,:exchange,:sic_code] })
		data_hash.each do |d|
			StockInfo.create(d)
		end
	end
end