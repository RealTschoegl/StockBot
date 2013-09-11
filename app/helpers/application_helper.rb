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
    		return "#{(qt.lastTrade).round(2)}"
		end
	end	

	# Public: This method determines whether a given stock is in the database already.
	#
	# Examples
	#
	#  	check_database_for_stock("YHOO")
	# 	# => true
	def check_database_for_stock(stock_symbol_name)
		if !Stock.where(:stock_ticker => stock_symbol_name).empty? 
			return true
		else
			return false
		end
	end
end


