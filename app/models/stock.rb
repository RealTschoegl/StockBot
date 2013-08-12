class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :current_stock_price, :expected_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

  	require 'yahoofinance' # Needed for current price

    def self.get_stock_price(stock_symbol_name)
      quote_type = YahooFinance::StandardQuote
      quote_symbols = stock_symbol_name
      YahooFinance::get_quotes( quote_type, quote_symbols ) do |qt|
        return "#{qt.lastTrade+1}"
      end
    end 

    def self.naming_test(stock_symbol_name)
    	Stock.where(:stock_ticker => stock_symbol_name).first.stock_ticker
    end

  	# @company_data = {
  	# 	 :stock_ticker_m => # @stock_ticker_symbol,
  	# 	 :company_m => # SELECT :company FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :free_cash_flow_m => # SELECT :free_cash_flow FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :num_shares_m => # SELECT :num_shares FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :PE_ratio_m => # SELECT :PE_ratio_m FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :dividend_per_share_m => # SELECT :dividend_per_share FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :dividend_growth_rate_m => # SELECT :dividened_growth_rate FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :beta_m => # SELECT :beta FROM Stocks WHERE :stock_ticker_m == :stock_ticker, 
  	# 	 :cost_of_equity_m => 0, 
  	# 	 :current_stock_price_m => 0, 
  	# 	 :expected_share_value_m => 0, 
  	# 	 :capm_share_value_m => 0, 
  	# 	 :dividend_share_value_m => 0, 
  	# 	 :composite_share_value_m => 0
  	# }

	# @@risk_free_rate = 0.0141 #5 year treasury yield at market
	# @@market_growth_rate = 0.2038 #S&P500 1 year growth rate

	# # This is the catchall that provides a complete valuation
	# def composite_valuation
	# 	free_cash_flow_method
	# 	dividend_discount_model
	# 	capm_method
	# 	@company_data.map do |category, value|
	# 		if value[:dividend_per_share_m] == 0
	# 			value[:composite_share_value_m] = ((value[:expected_share_value_m].to_f + value[:capm_share_value_m].to_f)/2).round(2)
	# 		else
	# 			value[:composite_share_value_m] = ((value[:expected_share_value_m].to_f + value[:dividend_share_value_m].to_f + value[:capm_share_value_m].to_f)/3).round(2)
	# 		end
	# 	end
	# 	time_value_of_money
	# end

	# # Vales the stock based on the FCF approach
	# def free_cash_flow_method
	# 	get_cost_of_equity
	# 	@company_data.map do |category, value|
	# 		value[:expected_share_value_m] += value[:free_cash_flow_m]/(value[:cost_of_equity_m]-(value[:PE_ratio_m]/100))
	# 	end
	# 	get_num_shares
	# end

	# # Value the stock based on the dividend discount method
	
	# def dividend_discount_model
	# 	get_stock_prices
	# 	@company_data.map do |category, value|
	# 		rate_of_return = (value[:dividend_per_share_m]/value[:current_stock_price_m]) + value[:dividend_growth_rate_m]
	# 		value[:dividend_share_value_m] += value[:dividend_per_share_m]/(rate_of_return - value[:dividend_growth_rate_m])
	# 	end
	# end
	
	# # Gets the present real price of the stock
	# def get_stock_prices
	# 	@company_data.each do |category, value|
	# 		quote_type = YahooFinance::StandardQuote
	# 		quote_symbols = "#{category}"
	# 		YahooFinance::get_quotes(quote_type, quote_symbols) do |qt|
	# 			value[:current_stock_price_m] = qt.lastTrade
	# 		end
	# 	end
	# end
	
	# # Finds the cost of equity for stock
	# def get_cost_of_equity
	# 	@company_data.map do |category, value|
	# 		value[:cost_of_equity_m] = @@risk_free_rate + value[:beta_m] * (@@market_growth_rate - @@risk_free_rate)
	# 	end
	# end

	# # Values the stock based on the CAPM method
	# def capm_method
	# 	capm_years = @years
	# 	get_cost_of_equity
	# 	get_stock_prices
	# 	@company_data.map do |category, value|
	# 		value[:capm_share_value_m] = (value[:cost_of_equity_m] + 1) * capm_years * value[:current_stock_price_m]
	# 	end
	# end
	# # Divides the value of the stock by the number of shares - useful for FCF 
	# def get_num_shares
	# 	puts @company_data.class
	# 	@company_data.map do |category, value|
	# 		value[:expected_share_value_m] = (value[:expected_share_value_m].to_f/value[:num_shares_m].to_f).round(2)
	# 	end
	# end

	# # Asks the user for a time horizon 
	# def years
	# 	puts "How many years do you want to hold the stock for?"
	# 	@years = gets.chomp.to_f
	# end

	# # Puts the company and it's values
	# def test
	# 	@company_data.each do |category, value|
	# 		puts category
	# 		puts value
	# 	end
	# 	return nil
	# end

	# # Takes the future value of the stock and changes it into the present value
	# def time_value_of_money
	# 	value[:composite_share_value_m] = value[:composite_share_value_m]/((1+@@market_growth_rate)**@years)
	# end
	
end

