module ValuationGenerator

	class Value

		## =================    Valuation Model   =====================

		#  This valuation model is an updated version of the stock valuation model for Stockbot.io

		## =================	  Notes   ===============================

		#  1 - Link: require "#{Rails.root}/lib/modules/valuation_generator.rb"

		## =================    The Call   ============================

		def self.compute_share_value(stock_ticker_symbol)

			if get_data(stock_ticker_symbol)

				@composite_share_value = 0
			  counter = 0

				get_ask && get_bid && get_low && get_high && get_last ? (@composite_share_value += method(:get_weighted_quote).call(stock_ticker_symbol) ; counter += 1) : (@composite_share_value += 0)

				get_PE_ratio && get_weighted_quote(stock_ticker_symbol) && get_market_cap ? (@composite_share_value += method(:get_PE_ratio_comparable).call(stock_ticker_symbol); counter += 1 ) : (@composite_share_value += 0)

				get_assets && get_debt && get_num_shares ? (@composite_share_value += method(:get_net_asset_value).call(stock_ticker_symbol); counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_riskFreeRate && get_beta && get_mktGrwthRateNSDQ && get_mktGrwthRateNYSE ? (@composite_share_value += method(:get_fcf_value_capm).call(stock_ticker_symbol); counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_market_cap && get_debt && get_250_MA_PRCT && get_hy_rate && get_ig_rate && get_riskFreeRate && get_beta && get_mktGrwthRateNSDQ && get_mktGrwthRateNYSE && get_tax ? (@composite_share_value += method(:get_fcf_value_wacc).call(stock_ticker_symbol) ; counter += 1 ) : (@composite_share_value += 0)

				get_forward_dividend_rate && get_trailing_dividend_rate && get_overnightDiscountRate && get_dividend_growth_rate ? (@composite_share_value += method(:get_dividend_value).call ; counter += 1 ) : (@composite_share_value += 0)

				get_Fiftyday_MA && get_50_MA_PRCT && get_bullish && get_bearish ? (@composite_share_value += method(:get_sentiment_value).call ; counter += 1 ) : (@composite_share_value += 0)

binding.pry

				@composite_share_value != 0 ? (@composite_share_value / counter) : (return false) 

			else 

				return false

			end
		end

		## =================    Valuation Equations   =================

		# Current Stock Price = (Asking Price + Bid Price + Days Low Price + Days High Price + Last Trade Price) / 5
		def self.get_weighted_quote(stock_ticker_symbol)
			quote_array = [@priceAsk, @priceBid, @priceLow, @priceHigh, @priceLast]
			@current_stock_price = quote_array.compact.reduce(:+) / quote_array.compact.count

			return @current_stock_price
		end

	  
		def self.get_PE_ratio_comparable(stock_ticker_symbol)
			comparables = get_comparables(stock_ticker_symbol)
			new_array = [] 
			comparables.each {|item| new_array << item.PE_ratio;}
			@PE_ratio_comp = @current_stock_price * ( ((new_array.inject(:+) / new_array.count).to_f) / @PE_ratio)

		  return @PE_ratio_comp
		end

		def self.get_net_asset_value(stock_ticker_symbol)
			@nav_per_share = ((@netAssets) - (@totalDebt)) / @numShares

			return @nav_per_share
		end

	  # FCF_CAPM = ((Operating Free Cash Flow [Forward]) / (CAPM Discount Rate - Expected OFCF Growth Rate)) / Number of Shares
		def self.get_fcf_value_capm(stock_ticker_symbol)
			@fcf_capm_share_value = (@freeCashFlow / (get_cost_of_equity_capm(stock_ticker_symbol) - @companyGrowth)) / @numShares

			return @fcf_capm_share_value
		  
		end
	  
		def self.get_fcf_value_wacc(stock_ticker_symbol)
			@fcf_wacc_share_value = (@freeCashFlow / (get_cost_of_equity_wacc(stock_ticker_symbol) - @companyGrowth)) / @numShares

		  return @fcf_wacc_share_value
		end

	  # Dividend Share Value = (Dividend Per Share [Forward]) / (Discount Rate - Dividend Growth Rate)
		def self.get_dividend_value
		  @dividend_share_value = @forwardDividendRate / (@overnightDiscountRate - @dividend_growth_rate)

		  return @dividend_share_value
		end

		def self.get_sentiment_value
			@sentiment_share_value = (@Fiftyday_MA) * ((1 + (@Fifty_MA_PRCT))**(1 + (@bullish - @bearish)))
		end

	  ## ===============  API Call  =================================

	  def self.get_data(stock_ticker_symbol)
	  	hydra = Typhoeus::Hydra.hydra

	  	first_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	second_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.keystats%20where%20symbol%20in%20(%22#{stock_ticker_symbol}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	third_url = "http://www.quandl.com/api/v1/datasets/OFDP/DMDRN_#{stock_ticker_symbol}_ALLFINANCIALRATIOS.csv?auth_token=#{ENV['QUANDL_API_TOKEN']}"
	  	fourth_url = "http://www.quandl.com/api/v1/datasets/PSYCH/#{stock_ticker_symbol}_I.json?&auth_token=auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{Time.now.change(:day => Time.now.day - 7).strftime("%F")}&trim_end=#{Time.now.strftime("%F")}&sort_order=desc"

	  	(((first_url) =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]) == 0) ? first_request = Typhoeus::Request.new(first_url) : (return false)
	  	second_request = Typhoeus::Request.new(second_url) 
	  	third_request = Typhoeus::Request.new(third_url) 
	  	fourth_request = Typhoeus::Request.new(fourth_url) 

	  	hydra.queue first_request
	  	hydra.queue second_request
	  	hydra.queue third_request
	  	hydra.queue fourth_request
	  	
	  	hydra.run

			first_request.response.options[:response_code] == 200 ? first_response = first_request.response :  (return false )
	  	second_response = second_request.response
	  	third_response = third_request.response 
	  	fourth_response = fourth_request.response

	  	@quotes = JSON.parse(first_response.body) if !first_response.body.nil?
	  	@key_stats = JSON.parse(second_response.body) 
	  	third_request.response.options[:response_code] == 200 ? @quandl_data = CSV.parse(third_response.body) : @quandl_data = nil
	  	fourth_request.response.options[:response_code] == 200 ? @psych_data = JSON.parse(fourth_response.body) : @psych_data = nil

	  	method(:assign_yahooQuotes).call
	  	method(:assign_yahooKeyStats).call(stock_ticker_symbol)
	  	method(:assign_quandlStockData).call(stock_ticker_symbol)
	  	method(:assign_quandlPsychData).call(stock_ticker_symbol)
	  	method(:assign_databaseValues).call(stock_ticker_symbol)

	  end

	  ## ===============  API Variables  ============================

	  def self.assign_yahooQuotes
	  	@quotes["query"]["results"]["quote"]["ErrorIndicationreturnedforsymbolchangedinvalid"].nil? ? @yahooQuote = @quotes["query"]["results"]["quote"] : (return false)
	  end

	  def self.assign_yahooKeyStats(stock_ticker_symbol)
	  	@key_stats["query"]["results"]["stats"]["Beta"] != nil ? @yahooKeyStats = @key_stats["query"]["results"]["stats"] : @yahooKeyStats = nil
	  end

	  def self.assign_quandlStockData(stock_ticker_symbol)
	  	if !@quandl_data.nil?
		  	headers_list = @quandl_data[0]
		  	data_list = @quandl_data[1]
		  	@quandlStockData = {}
		  	headers_list.each_index { |x| @quandlStockData[headers_list[x]] = data_list[x] }
		  else
		  	@quandlStockData = nil
		  end
	  end

	  def self.assign_quandlPsychData(stock_ticker_symbol)
	  	if !@psych_data.nil?
	  		@quandlPsychData = @psych_data["data"][0]
	  	else
	  		@quandlPsychData = nil
	  	end
	  end

	  def self.assign_databaseValues(stock_ticker_symbol)
	  	val = Stock.where(stock_ticker: stock_ticker_symbol).first
	  	!val.nil? ? (return @databaseValues = val) : true
	  end

		## ===============  Basic Variables  ==========================

		def self.get_forward_dividend_rate
			if !@yahooKeyStats["ForwardAnnualDividendRate"].nil?
				@forwardDividendRate = @yahooKeyStats["ForwardAnnualDividendRate"].to_f
			elsif !@databaseValues["forw_div_rate"].nil?
				@forwardDividendRate = @databaseValues["forw_div_rate"]
			else 
				return @forwardDividendRate = nil
			end
		end

		def self.get_trailing_dividend_rate
			if !@yahooKeyStats["TrailingAnnualDividendYield"][0].nil?
				@trailingDividendRate = @yahooKeyStats["TrailingAnnualDividendYield"][0].to_f
			elsif !@databaseValues["trail_div_rate"].nil?
				@trailingDividendRate = @databaseValues["trail_div_rate"]
			else
				return @trailingDividendRate = nil
			end
		end

		def self.get_num_shares
			if !@yahooKeyStats["Float"].nil?
				@numShares = @yahooKeyStats["Float"].to_i
			elsif !@databaseValues["num_shares"].nil?
				@numShares = @databaseValues["num_shares"]
			else
				return @numShares = nil
			end
		end

		def self.get_free_cash_flow
			if !@yahooKeyStats["OperatingCashFlow"]["content"].nil?
				@freeCashFlow = @yahooKeyStats["OperatingCashFlow"]["content"].to_f
			elsif !@databaseValues["free_cash_flow"].nil?
				@freeCashFlow = @databaseValues["free_cash_flow"]
			else
				return @freeCashFlow = nil
			end
		end

		def self.get_company_growth
			if !@quandlStockData["Expected Growth in Earnings Per Share"].nil?
				@companyGrowth = @quandlStockData["Expected Growth in Earnings Per Share"].to_f
			elsif !@databaseValues["earnings_growth"].nil?
				@companyGrowth = @databaseValues["earnings_growth"]
			else 
				@companyGrowth = nil
			end
		end

		def self.get_PE_ratio
			if !@quandlStockData["Trailing PE Ratio"].nil?
				@PE_ratio = @quandlStockData["Trailing PE Ratio"].to_f
			elsif !@databaseValues["PE_ratio"].nil?
				@PE_ratio = @databaseValues["PE_ratio"]
			else
				@PE_ratio = nil
			end
		end

		def self.get_assets
			if !@quandlStockData["Book Value of Assets"].nil?
				@netAssets = @quandlStockData["Book Value of Assets"].to_i * 1_000_000
			elsif !@databaseValues["assets"].nil?
				@netAssets = @databaseValues["assets"]
			else
				@netAssets = nil
			end
		end

		def self.get_beta
			if !@quandlStockData["3-Year Regression Beta"].nil?
				@regBeta = @quandlStockData["3-Year Regression Beta"].to_f
			elsif !@databaseValues["beta"].nil?
				@regBeta = @databaseValues["beta"]
			else
				@regBeta = nil
			end
		end

		def self.get_debt
			if !@quandlStockData["Total Debt"].nil?
				@totalDebt = @quandlStockData["Total Debt"].to_f * 1_000_000
			elsif !@databaseValues["beta"].nil?
				@totalDebt = @databaseValues["beta"]
			else
				@totalDebt = nil
			end
		end


		def self.get_tax
			if !@quandlStockData["Effective Tax Rate"].nil?
				@taxRate = @quandlStockData["Effective Tax Rate"].to_f
			elsif !@databaseValues["eff_tax_rate"].nil?
				@taxRate = @databaseValues["eff_tax_rate"]
			else
				@taxRate = nil
			end
		end
			
		
		def self.get_market_cap
			if !@quandlStockData["Market Capitalization"].nil?
				@marketCap = @quandlStockData["Market Capitalization"].to_i
			elsif !@databaseValues["mkt_cap"].nil?
				@marketCap = @databaseValues["mkt_cap"]
			else
				@marketCap = nil
			end
		end

		def self.get_Fiftyday_MA
			!@yahooQuote["FiftydayMovingAverage"].nil? ? @Fiftyday_MA = @yahooQuote["FiftydayMovingAverage"].to_f : @Fiftyday_MA = nil
		end

		def self.get_50_MA_PRCT
			!@yahooQuote["PercentChangeFromFiftydayMovingAverage"].nil? ? @Fifty_MA_PRCT = (@yahooQuote["PercentChangeFromFiftydayMovingAverage"].to_f / 100) : @Fifty_MA_PRCT = nil
		end

		def self.get_250_MA_PRCT
			!@yahooQuote["PercentChangeFromTwoHundreddayMovingAverage"].nil? ? @TwoFifty_MA_PRCT = @yahooQuote["PercentChangeFromTwoHundreddayMovingAverage"].to_f : @TwoFifty_MA_PRCT = nil 
		end

		def self.get_ask
			!@yahooQuote["Ask"].nil? ? @priceAsk = @yahooQuote["Ask"].to_f : @priceAsk = nil
		end

		def self.get_bid
			!@yahooQuote["Bid"].nil? ? @priceBid = @yahooQuote["Bid"].to_f : @priceBid = nil
		end

		def self.get_low
			!@yahooQuote["DaysLow"].nil? ? @priceLow = @yahooQuote["DaysLow"].to_f : @priceLow = nil
		end

		def self.get_high
			!@yahooQuote["DaysHigh"].nil? ? @priceHigh = @yahooQuote["DaysHigh"].to_f : @priceHigh = nil
		end

		def self.get_last
			!@yahooQuote["LastTradePriceOnly"].nil? ? @priceLast = @yahooQuote["LastTradePriceOnly"].to_f : @priceLast = nil
		end

		def self.get_bullish
			!@quandlPsychData[1].nil? ? @bullish = @quandlPsychData[1].to_f : @bullish = nil
		end

		def self.get_bearish
			!@quandlPsychData[2].nil? ? @bearish = @quandlPsychData[2].to_f : @bearish = nil
		end

		def self.get_riskFreeRate
			@riskFreeRate = $financialConstant.get("riskFreeRate").to_f
		end

		def self.get_overnightDiscountRate
			@overnightDiscountRate = $financialConstant.get("overnightDiscountRate").to_f
		end

		def self.get_hy_rate
			@highYieldRate = $financialConstant.get("highYieldBond").to_f
		end

		def self.get_ig_rate
			@investGradeRate = $financialConstant.get("investmentGradeBond").to_f
		end	

		def self.get_mktGrwthRateNSDQ
			@gwthRateNSDQ = ($financialConstant.get("marketGrowthRateNSDQ").to_f).round(4)
		end

		def self.get_mktGrwthRateNYSE
			@gwthRateNYSE = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4)
		end
		
		## ===============  Helper Variables  ========================

		def self.get_comparables(stock_ticker_symbol)
			if @sorted_comparables.nil?
				stock_mkt_cap = @marketCap
				our_stock = Stock.where(stock_ticker: stock_ticker_symbol).first
				stock_sector = our_stock.sic_code
				stock_identifier = our_stock.id
				@rough_comparables = Stock.sector(stock_identifier, stock_sector)
				@sorted_comparables = @rough_comparables.where("? < mkt_cap < ?", stock_mkt_cap/5, stock_mkt_cap*5).all
				return @sorted_comparables
			else
				return @sorted_comparables
			end
		end

		def self.get_dividend_growth_rate
			@dividend_growth_rate = (@forwardDividendRate - @trailingDividendRate) / @trailingDividendRate

			return @dividend_growth_rate
		end

		def self.get_cost_of_equity_capm(stock_ticker_symbol)
			@cost_of_equity_capm = @riskFreeRate + @regBeta * (get_exchange(stock_ticker_symbol) - @riskFreeRate)

			return @cost_of_equity_capm
		end

		def self.get_cost_of_equity_wacc(stock_ticker_symbol)
			total = @marketCap + @totalDebt
			@cost_of_equity_wacc = ((@marketCap) / (total) * @cost_of_equity_capm) + (((@totalDebt) / (total)) * get_cost_of_debt * (1 - @taxRate))
		end

		def self.get_cost_of_debt
			if @TwoFifty_MA_PRCT < -15
				return @highYieldRate
			else
				return @investGradeRate
			end
		end
		

		def self.get_exchange(stock_ticker_symbol)
      if StockInfo.where(ticker_sign: stock_ticker_symbol).first.exchange == "NASDAQ"
       	return @gwthRateNSDQ
      else
        return @gwthRateNYSE 
      end
    end
	end

end