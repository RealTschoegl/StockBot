class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :current_stock_price, :expected_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

  	require 'yahoofinance' # Needed for current price

	@@risk_free_rate = 0.0141 #5 year treasury yield at market
	@@market_growth_rate = 0.2038 #S&P500 1 year growth rate

	# This is the catchall that provides a complete valuation
	def self.composite_valuation
		free_cash_flow_method
		dividend_discount_model
		capm_method
		@@companies.map do |company, value|
			if value[:dividend_per_share] == 0
				value[:composite_share_value] = ((value[:expected_share_value].to_f + value[:capm_share_value].to_f)/2).round(2)
			else
				value[:composite_share_value] = ((value[:expected_share_value].to_f + value[:dividend_share_value].to_f + value[:capm_share_value].to_f)/3).round(2)
			end
		end
		time_value_of_money
	end

	# Vales the stock based on the FCF approach
	def self.free_cash_flow_method
		get_cost_of_equity
		@@companies.map do |company, value|
			value[:expected_share_value] += value[:free_cash_flow]/(value[:cost_of_equity]-(value[:PE_ratio]/100))
		end
		num_shares
	end

	# Value the stock based on the dividend discount method
	
	def self.dividend_discount_model
		get_stock_prices
		@@companies.map do |company, value|
			rate_of_return = (value[:dividend_per_share]/value[:current_stock_price]) + value[:dividend_growth_rate]
			value[:dividend_share_value] += value[:dividend_per_share]/(rate_of_return - value[:dividend_growth_rate])
		end
	end
	
	# Gets the present real price of the stock
	def self.get_stock_prices
		@@companies.each do |company, value|
			quote_type = YahooFinance::StandardQuote
			quote_symbols = "#{company}"
			YahooFinance::get_quotes(quote_type, quote_symbols) do |qt|
				value[:current_stock_price] = qt.lastTrade
			end
		end
	end
	
	# Finds the cost of equity for stock
	def self.get_cost_of_equity
		@@companies.map do |company, value|
			value[:cost_of_equity] = @@risk_free_rate + value[:beta] * (@@market_growth_rate - @@risk_free_rate)
		end
	end
	
	# Values the stock based on the CAPM method
	def self.capm_method
		capm_years = @@years
		get_cost_of_equity
		get_stock_prices
		@@companies.map do |company, value|
			value[:capm_share_value] = (value[:cost_of_equity] + 1) * capm_years * value[:current_stock_price]
		end

	end

	# Divides the value of the stock by the number of shares - useful for FCF 
	def self.num_shares
		@@companies.map do |company, value|
			value[:expected_share_value] = (value[:expected_share_value].to_f/value[:num_shares].to_f).round(2)
		end
	end

	# Asks the user for a time horizon 
	def self.years
		puts "How many years do you want to hold the stock for?"
		@@years = gets.chomp.to_f
	end

	# Puts the company and it's values
	def self.test
		@@companies.each do |company, value|
			puts company
			puts value
		end
		return nil
	end

	# Takes the future value of the stock and changes it into the present value
	def self.time_value_of_money
		value[:composite_share_value] = value[:composite_share_value]/((1+@@market_growth_rate)^^@@years)
	end
	
end

