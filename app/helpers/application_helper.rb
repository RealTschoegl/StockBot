require 'yahoofinance'

# Public: These methods assist the user experience by adding data or validations to the views.  
module ApplicationHelper
	# Public: This method gets the last traded stock price for a given stock.  
	#
	# Example
	#
	# 	get_stock_prices("YHOO")
	# 	# => 23.32 
	def get_stock_prices(stock_symbol_name)
		quote_type = YahooFinance::StandardQuote
		quote_symbols = stock_symbol_name
		YahooFinance::get_quotes( quote_type, quote_symbols ) do |qt|
    		return '%.2f' % qt.lastTrade
		end
	end

	def title(page_title)
  	content_for :title, page_title.to_s
	end	
end


