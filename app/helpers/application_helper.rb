require 'yahoofinance'

module ApplicationHelper
	def get_stock_prices(stock_symbol_name)
		quote_type = YahooFinance::StandardQuote
		quote_symbols = stock_symbol_name
		YahooFinance::get_quotes( quote_type, quote_symbols ) do |qt|
    		return "#{(qt.lastTrade).round(2)}"
		end
	end	

	def check_database_for_stock(stock_symbol_name)
		if !Stock.where(:stock_ticker => stock_symbol_name).empty? 
			return true
		else
			return false
		end
	end
end


