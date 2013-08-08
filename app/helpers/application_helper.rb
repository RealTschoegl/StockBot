require 'yahoofinance'

module ApplicationHelper
	def get_stock_prices(stock_symbol_name)
		quote_type = YahooFinance::StandardQuote
		quote_symbols = stock_symbol_name
		YahooFinance::get_quotes( quote_type, quote_symbols ) do |qt|
    		return "#{qt.lastTrade}"
		end
	end	
end
