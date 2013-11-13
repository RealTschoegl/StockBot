module ValuationGenerator

	class Value

		## =================    Valuation Model   =====================
		## This valuation model is an updated version of the stock valuation model for Stockbot.io

		## =================	  Notes   ===============================
		# 1 - Maybe use the one year target price in the get_current_stock_price method?
		# 2 - Link: require "#{Rails.root}/lib/modules/valuation_generator.rb"

		## =================    The Call   ============================

		def self.compute_share_value(stock_ticker_symbol)

			get_data(stock_ticker_symbol)

			@composite_share_value = 0
		  counter = 0

			@composite_share_value += method(:get_weighted_quote).call(stock_ticker_symbol); counter += 1
			@composite_share_value += method(:get_PE_ratio_comparable).call(stock_ticker_symbol); counter += 1
			@composite_share_value += method(:get_net_asset_value).call(stock_ticker_symbol); counter += 1
			@composite_share_value += method(:get_fcf_value_capm).call(stock_ticker_symbol); counter += 1
			@composite_share_value += method(:get_fcf_value_wacc).call(stock_ticker_symbol); counter += 1
			@composite_share_value += method(:get_dividend_value).call; counter += 1 
			
			return (@composite_share_value / counter)
		end

		## =================    Valuation Equations   =================

		# Current Stock Price = (Asking Price + Bid Price + Days Low Price + Days High Price + Last Trade Price) / 5
		def self.get_weighted_quote(stock_ticker_symbol)
			@current_stock_price = (@yahooQuote["Ask"].to_f + @yahooQuote["Bid"].to_f + @yahooQuote["DaysLow"].to_f + @yahooQuote["DaysHigh"].to_f + @yahooQuote["LastTradePriceOnly"].to_f) / 5

			return @current_stock_price
		end

	  
		def self.get_PE_ratio_comparable(stock_ticker_symbol)
			comparables = get_comparables(stock_ticker_symbol)

			new_array = [] 
			comparables.each {|item| new_array << item.PE_ratio;}
			@PE_ratio_comp = @current_stock_price * ( (new_array.inject(:+) / new_array.count).to_f / @quandlStockData["Trailing PE Ratio"].to_f)
			
		  return @PE_ratio_comp
		end

		def self.get_net_asset_value(stock_ticker_symbol)
			@nav_per_share = ((@quandlStockData["Book Value of Assets"].to_i * 1_000_000) - (@quandlStockData["Total Debt"].to_i * 1_000_000)) / @yahooKeyStats["Float"].to_i

			return @nav_per_share
		end

	  # FCF_CAPM = ((Operating Free Cash Flow [Forward]) / (CAPM Discount Rate - Expected OFCF Growth Rate)) / Number of Shares
		def self.get_fcf_value_capm(stock_ticker_symbol)
			@fcf_capm_share_value = (@yahooKeyStats["OperatingCashFlow"]["content"].to_f / (get_cost_of_equity_capm(stock_ticker_symbol) - @quandlStockData["Expected Growth in Earnings Per Share"].to_f)) / @yahooKeyStats["Float"].to_i

			return @fcf_capm_share_value
		  
		end
	  
		def self.get_fcf_value_wacc(stock_ticker_symbol)
			@fcf_wacc_share_value = (@yahooKeyStats["OperatingCashFlow"]["content"].to_f / (get_cost_of_equity_wacc(stock_ticker_symbol) - @quandlStockData["Expected Growth in Earnings Per Share"].to_f)) / @yahooKeyStats["Float"].to_i

		  return @fcf_wacc_share_value
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

	  	first_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	second_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.keystats%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	third_url = "http://www.quandl.com/api/v1/datasets/OFDP/DMDRN_#{stock_ticker_symbol}_ALLFINANCIALRATIOS.csv?auth_token=#{ENV['QUANDL_API_TOKEN']}"

	  	first_request = Typhoeus::Request.new(first_url) if (((first_url) =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]) == 0)
	  	second_request = Typhoeus::Request.new(second_url) if (((second_url) =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]) == 0)
	  	third_request = Typhoeus::Request.new(third_url) if (((third_url) =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]) == 0)

	  	hydra.queue first_request
	  	hydra.queue second_request
	  	hydra.queue third_request
	  	
	  	hydra.run

	  	first_response = first_request.response if first_request.response.options[:response_code] == 200
	  	second_response = second_request.response if second_request.response.options[:response_code] == 200
	  	third_response = third_request.response if third_request.response.options[:response_code] == 200

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

		def self.get_comparables(stock_ticker_symbol)
			if @sorted_comparables.nil?
				stock_mkt_cap = @quandlStockData["Market Capitalization"].to_i
				stock_sector = Stock.where(stock_ticker: stock_ticker_symbol).first.sic_code
				rough_comparables = Stock.sector(stock_sector)
				@sorted_comparables = rough_comparables.where("? < mkt_cap < ?", stock_mkt_cap/5, stock_mkt_cap*5).all
				return @sorted_comparables
			else
				return @sorted_comparables
			end
		end

		def self.get_dividend_growth_rate
			@dividend_growth_rate = (@yahooKeyStats["ForwardAnnualDividendRate"].to_f - @yahooKeyStats["TrailingAnnualDividendYield"[0]].to_f) / 2

			return @dividend_growth_rate
		end

		def self.get_cost_of_equity_capm(stock_ticker_symbol)
			@cost_of_equity_capm = $financialConstant.get("riskFreeRate").to_f + @quandlStockData["3-Year Regression Beta"].to_f * (get_exchange(stock_ticker_symbol) - $financialConstant.get("riskFreeRate").to_f)

			return @cost_of_equity_capm
		end

		def self.get_cost_of_equity_wacc(stock_ticker_symbol)
			total = @quandlStockData["Market Capitalization"].to_f + @quandlStockData["Total Debt"].to_f
			@cost_of_equity_wacc = ((@quandlStockData["Market Capitalization"].to_i) / (total) * @cost_of_equity_capm) + (((@quandlStockData["Total Debt"].to_i) / (total)) * get_cost_of_debt * (1 - @quandlStockData["Effective Tax Rate"].to_f))
		end

		def self.get_cost_of_debt
			if @yahooQuote["PercentChangeFromTwoHundreddayMovingAverage"].to_f < -15
				return $financialConstant.get("highYieldBond").to_f
			else
				return $financialConstant.get("investmentGradeBond").to_f
			end
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