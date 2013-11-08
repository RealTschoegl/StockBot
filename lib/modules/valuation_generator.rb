require "typhoeus"
# require "#{Rails.root}/lib/modules/valuation_generator.rb"

module ValuationGenerator

	class Value

		## =================    Valuation Model   =====================
		## This valuation model is an updated version of the stock valuation model for Stockbot.io

		## =================	  Notes   ===============================
		# 1 - Maybe use the one year target price in the get_current_stock_price method?

		## =================    The Call   ============================

		def self.compute_share_value(stock_ticker_symbol)
			get_data(stock_ticker_symbol)
		  @composite_share_value = (get_weighted_quote(stock_ticker_symbol) + get_comparables + get_fcf_value_capm(stock_ticker_symbol) + get_fcf_value_wacc + get_dividend_value) / 5
		end

		## =================    Valuation Equations   =================

		# Current Stock Price = (Asking Price + Bid Price + Days Low Price + Days High Price + Last Trade Price) / 5
		def self.get_weighted_quote(stock_ticker_symbol)
			@current_stock_price = (@yahooQuote["Ask"].to_f + @yahooQuote["Bid"].to_f + @yahooQuote["DaysLow"].to_f + @yahooQuote["DaysHigh"].to_f + @yahooQuote["LastTradePriceOnly"].to_f) / 5

			return @current_stock_price
		end

	  
		def self.get_comparables
		  return 0
		end

	  # FCF_CAPM = ((Operating Free Cash Flow [Forward]) / (CAPM Discount Rate - Expected OFCF Growth Rate)) / Number of Shares
		def self.get_fcf_value_capm(stock_ticker_symbol)
			return (@yahooKeyStats["OperatingCashFlow"]["content"].to_f / (get_cost_of_equity(stock_ticker_symbol) - @quandlStockData["Expected Growth in Earnings Per Share"].to_f))/ @yahooKeyStats["float"].to_f
		  
		end

	  # FCF_WACC = ((Operating Free Cash Flow [Forward]) / (WACC Discount Rate - Expected OFCF Growth Rate)) / Number of Shares
	  # WACC Discount Rate = ((Market Value of Equity) / (Equity + Debt) * Cost of Equity) + ((Market Value of Debt) / (Equity + Debt) * Cost of Debt * (1 - Effective Tax Rate))
		def self.get_fcf_value_wacc
		  return 0
		end

	  # Dividend Share Value = (Dividend Per Share [Forward]) / (Discount Rate - Dividend Growth Rate)
		def self.get_dividend_value
		  @dividend_share_value = @yahooKeyStats["ForwardAnnualDividendRate"].to_f / ( $financialConstant.get("overnightDiscountRate").to_f - get_dividend_growth_rate)

		  return @dividend_share_value
		end

		## ===============  Computed Constants  =======================

	  ## ===============  API Call  =================================

	  def self.get_data(stock_ticker_symbol)
	  	hydra = Typhoeus::Hydra.hydra

	  	first_request = Typhoeus::Request.new("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env", params: {format: "json" })
	  	second_request = Typhoeus::Request.new("http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.keystats%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env",
	  		params: {format:"json"})
	  	third_request = Typhoeus::Request.new("http://www.quandl.com/api/v1/datasets/OFDP/DMDRN_#{stock_ticker_symbol}_ALLFINANCIALRATIOS.csv?auth_token=#{ENV['QUANDL_API_TOKEN']}")
	  			

	  	hydra.queue first_request
	  	hydra.queue second_request
	  	hydra.queue third_request
	  	
	  	hydra.run

	  	first_response = first_request.response
	  	second_response = second_request.response
	  	third_response = third_request.response

	  	a = JSON.parse(first_response.body)
	  	b = JSON.parse(second_response.body)
	  	headers_list = CSV.parse(third_response.body)[0]
	  	data_list = CSV.parse(third_response.body)[1]

	  	@yahooQuote = a["query"]["results"]["quote"]
	  	@yahooKeyStats = b["query"]["results"]["stats"]
	  	@quandlStockData = {}
	  	headers_list.each_index { |x| @quandlStockData[headers_list[x]] = data_list[x] } 

	  end

		## ===============  Basic Variables  ==========================

		# stock_ticker_symbol
	  # current_stock_price
	  # - Ask
	  # - Bid
	  # - DaysLow
	  # - DaysHigh
	  # - LastTradePriceOnly
		# dividend_per_share
	  # - Forward Year
	  # - Previous Year
		# discount_rate (rate for borrowing from fed)

		## ===============  Helper Variables  ========================

		def self.get_dividend_growth_rate
			@dividend_growth_rate = (@yahooKeyStats["ForwardAnnualDividendRate"].to_f - @yahooKeyStats["TrailingAnnualDividendYield"[0]].to_f) / 2

			return @dividend_growth_rate
		end

		def self.get_cost_of_equity(stock_ticker_symbol)
			@get_cost_of_equity = $financialConstant.get("riskFreeRate").to_f + @quandlStockData["3-Year Regression Beta"].to_f * (get_exchange(stock_ticker_symbol) - $financialConstant.get("riskFreeRate").to_f)

			return @get_cost_of_equity
		end

		def self.get_exchange(stock_ticker_symbol)
      if StockInfo.where(ticker_sign: stock_ticker_symbol).first.exchange == "NASDAQ"
       	return ($financialConstant.get("marketGrowthRateNSDQ").to_f).round(4)
      else
        return ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4) 
      end
    end
	end

end