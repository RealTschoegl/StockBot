class BackgroundWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(data)
		if Stock.where(stock_ticker: data["stock_ticker"]).first
			Stock.update_stock(data)
		else
			Stock.new_stock(data)
		end

		Company.build_company(data)
	end
end