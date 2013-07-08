class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :current_stock_price, :expected_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

  	require 'yahoofinance' # Needed for current price

  	# @company_data = {
  	# 	 :company => # From User, 
  	# 	 :stock_ticker => # From User, 
  	# 	 :free_cash_flow => # From Database, 
  	# 	 :num_shares => # From Database, 
  	# 	 :PE_ratio => # From Database, 
  	# 	 :dividend_per_share => # From Database, 
  	# 	 :dividend_growth_rate => # From Database, 
  	# 	 :beta => # From Database, 
  	# 	 :cost_of_equity => # Calculated Here, 
  	# 	 :current_stock_price => # Calculated Here, 
  	# 	 :expected_share_value => # Calculated Here, 
  	# 	 :capm_share_value => # Calculated Here, 
  	# 	 :dividend_share_value => # Calculated Here, 
  	# 	 :composite_share_value => # Calculated Here 
  	# }

	@@risk_free_rate = 0.0141 #5 year treasury yield at market
	@@market_growth_rate = 0.2038 #S&P500 1 year growth rate

	# This is the catchall that provides a complete valuation
	def composite_valuation
		free_cash_flow_method
		dividend_discount_model
		capm_method
		@company_data.map do |category, value|
			if value[:dividend_per_share] == 0
				value[:composite_share_value] = ((value[:expected_share_value].to_f + value[:capm_share_value].to_f)/2).round(2)
			else
				value[:composite_share_value] = ((value[:expected_share_value].to_f + value[:dividend_share_value].to_f + value[:capm_share_value].to_f)/3).round(2)
			end
		end
		time_value_of_money
	end

	# Vales the stock based on the FCF approach
	def free_cash_flow_method
		get_cost_of_equity
		@company_data.map do |category, value|
			value[:expected_share_value] += value[:free_cash_flow]/(value[:cost_of_equity]-(value[:PE_ratio]/100))
		end
		num_shares
	end

	# Value the stock based on the dividend discount method
	
	def dividend_discount_model
		get_stock_prices
		@company_data.map do |category, value|
			rate_of_return = (value[:dividend_per_share]/value[:current_stock_price]) + value[:dividend_growth_rate]
			value[:dividend_share_value] += value[:dividend_per_share]/(rate_of_return - value[:dividend_growth_rate])
		end
	end
	
	# Gets the present real price of the stock
	def get_stock_prices
		@company_data.each do |category, value|
			quote_type = YahooFinance::StandardQuote
			quote_symbols = "#{category}"
			YahooFinance::get_quotes(quote_type, quote_symbols) do |qt|
				value[:current_stock_price] = qt.lastTrade
			end
		end
	end
	
	# Finds the cost of equity for stock
	def get_cost_of_equity
		@company_data.map do |category, value|
			value[:cost_of_equity] = @@risk_free_rate + value[:beta] * (@@market_growth_rate - @@risk_free_rate)
		end
	end

	# Values the stock based on the CAPM method
	def capm_method
		capm_years = @years
		get_cost_of_equity
		get_stock_prices
		@company_data.map do |category, value|
			value[:capm_share_value] = (value[:cost_of_equity] + 1) * capm_years * value[:current_stock_price]
		end
	end
	# Divides the value of the stock by the number of shares - useful for FCF 
	def get_num_shares
		puts @company_data.class
		@company_data.map do |category, value|
			value[:expected_share_value] = (value[:expected_share_value].to_f/value[:num_shares].to_f).round(2)
		end
	end

	# Asks the user for a time horizon 
	def years
		puts "How many years do you want to hold the stock for?"
		@years = gets.chomp.to_f
	end

	# Puts the company and it's values
	def test
		@company_data.each do |category, value|
			puts category
			puts value
		end
		return nil
	end

	# Takes the future value of the stock and changes it into the present value
	def time_value_of_money
		value[:composite_share_value] = value[:composite_share_value]/((1+@@market_growth_rate)**@years)
	end
	
end

