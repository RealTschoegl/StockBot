namespace :updater do

	desc "Update the stock data through an API call"
	task :refresh => :environment do
		time = Time.now.change(:month => Time.now.month - 1)
		Stock.updated_before(time).find_each do |stock|
			Stock.get_stock(stock.stock_ticker)
		end
		
	end

end