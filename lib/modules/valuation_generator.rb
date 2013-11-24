## =================    Valuation Model   =====================

#  This valuation model is an updated version of the stock valuation model for Stockbot.io

## =================	  Notes   ===============================

#  1 - Link: require "#{Rails.root}/lib/modules/valuation_generator.rb"

module ValuationGenerator

	class Value

		## ================= 		Initialize   ==========================

		attr_accessor :stock_ticker, :current_stock_price, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :rate_of_return, :fcf_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

		def initialize(stock_ticker_symbol)
      @stock_ticker = stock_ticker_symbol
  	end

		## =================    The Call   ============================

		def compute_share_value

			if get_data

				@composite_share_value = 0
			  counter = 0

				get_PE_ratio && get_weighted_quote && get_market_cap && get_comparables ? (@composite_share_value += method(:get_PE_ratio_comparable).call; counter += 1 ) : (@composite_share_value += 0)

				get_assets && get_debt && get_num_shares ? (@composite_share_value += method(:get_net_asset_value).call; counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_riskFreeRate && get_beta && get_mktGrwthRateNSDQ && get_mktGrwthRateNYSE && get_cost_of_equity_capm ? (@composite_share_value += method(:get_fcf_value_capm).call; counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_market_cap && get_debt && get_250_MA_PRCT && get_hy_rate && get_ig_rate && get_riskFreeRate && get_beta && get_mktGrwthRateNSDQ && get_mktGrwthRateNYSE && get_tax && get_cost_of_equity_capm ? (@composite_share_value += method(:get_fcf_value_wacc).call; counter += 1 ) : (@composite_share_value += 0)

				get_forward_dividend_rate && get_trailing_dividend_rate && get_overnightDiscountRate && get_dividend_growth_rate ? (@composite_share_value += method(:get_dividend_value).call ; counter += 1 ) : (@composite_share_value += 0)

				get_Fiftyday_MA && get_50_MA_PRCT && get_bullish && get_bearish ? (@composite_share_value += method(:get_sentiment_value).call ; counter += 1 ) : (@composite_share_value += 0)

				@composite_share_value != 0 ? (@composite_share_value / counter) : (return false) 
			else 

				return false

			end
		end

		## =================    Valuation Equations   =================
	  
		def get_PE_ratio_comparable
			comparables = @sorted_comparables
			new_array = [] 
			comparables.each {|item| new_array << item.PE_ratio;}
			@PE_ratio_comp = @current_stock_price * ( ((new_array.inject(:+) / new_array.count).to_f) / @PE_ratio)

		  return @PE_ratio_comp
		end

		def get_net_asset_value
			@nav_per_share = ((@netAssets) - (@totalDebt)) / @numShares

			return @nav_per_share
		end

	  # FCF_CAPM = ((Operating Free Cash Flow [Forward]) / (CAPM Discount Rate - Expected OFCF Growth Rate)) / Number of Shares
		def get_fcf_value_capm
			@fcf_capm_share_value = (@freeCashFlow / (@cost_of_equity_capm - @companyGrowth)) / @numShares

			return @fcf_capm_share_value
		end

		def get_fcf_value_wacc
			@fcf_wacc_share_value = (@freeCashFlow / (@cost_of_equity_capm - @companyGrowth)) / @numShares

		  return @fcf_wacc_share_value
		end

	  # Dividend Share Value = (Dividend Per Share [Forward]) / (Discount Rate - Dividend Growth Rate)
		def get_dividend_value
		  @dividend_share_value = @forwardDividendRate / (@overnightDiscountRate - @dividend_growth_rate)

		  return @dividend_share_value
		end

		def get_sentiment_value
			@sentiment_share_value = (@Fiftyday_MA) * ((1 + (@Fifty_MA_PRCT))**(1 + (@bullish - @bearish)))
		end

	  ## ===============  API Call  =================================

	  def get_data
	  	hydra = Typhoeus::Hydra.hydra

	  	first_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22#{self.stock_ticker}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	second_url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.keystats%20where%20symbol%20in%20(%22#{self.stock_ticker}%22)&format=json%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
	  	third_url = "http://www.quandl.com/api/v1/datasets/OFDP/DMDRN_#{self.stock_ticker}_ALLFINANCIALRATIOS.csv?auth_token=#{ENV['QUANDL_API_TOKEN']}"
	  	fourth_url = "http://www.quandl.com/api/v1/datasets/PSYCH/#{self.stock_ticker}_I.json?&auth_token=auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{Time.now.change(:day => Time.now.day - 7).strftime("%F")}&trim_end=#{Time.now.strftime("%F")}&sort_order=desc"

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
	  	method(:assign_yahooKeyStats).call
	  	method(:assign_quandlStockData).call
	  	method(:assign_quandlPsychData).call
	  	method(:assign_databaseValues).call

	  end

	  ## ===============  API Variables  ============================

	  def assign_yahooQuotes
	  	@quotes["query"]["results"]["quote"]["ErrorIndicationreturnedforsymbolchangedinvalid"].nil? ? @yahooQuote = @quotes["query"]["results"]["quote"] : (return false)
	  end

	  def assign_yahooKeyStats
	  	!@key_stats["query"]["results"]["stats"]["Beta"].nil? ? @yahooKeyStats = @key_stats["query"]["results"]["stats"] : @yahooKeyStats = nil
	  end

	  def assign_quandlStockData
	  	if !@quandl_data.nil?
		  	headers_list = @quandl_data[0]
		  	data_list = @quandl_data[1]
		  	@quandlStockData = {}
		  	headers_list.each_index { |x| @quandlStockData[headers_list[x]] = data_list[x] }
		  else
		  	@quandlStockData = nil
		  end
	  end

	  def assign_quandlPsychData
	  	if !@psych_data.nil?
	  		@quandlPsychData = @psych_data["data"][0]
	  	else
	  		@quandlPsychData = nil
	  	end
	  end

	  def assign_databaseValues
	  	val = Stock.where(stock_ticker: self.stock_ticker).first
	  	!val.nil? ? (return @databaseValues = val) : true
	  end

		## ===============  Basic Variables  ==========================

		def get_forward_dividend_rate
			if @forwardDividendRate.nil?
				if !@yahooKeyStats["ForwardAnnualDividendRate"].nil?
					@forwardDividendRate = @yahooKeyStats["ForwardAnnualDividendRate"].to_f
				elsif !@databaseValues["forw_div_rate"].nil?
					@forwardDividendRate = @databaseValues["forw_div_rate"]
				else 
					return @forwardDividendRate = nil
				end
			else
				return true
			end
		end

		def get_trailing_dividend_rate
			if @trailingDividendRate.nil?
				if !@yahooKeyStats["TrailingAnnualDividendYield"][0].nil?
					@trailingDividendRate = @yahooKeyStats["TrailingAnnualDividendYield"][0].to_f
				elsif !@databaseValues["trail_div_rate"].nil?
					@trailingDividendRate = @databaseValues["trail_div_rate"]
				else
					return @trailingDividendRate = nil
				end
			else
				return true
			end
		end

		def get_num_shares
			if @numShares.nil?
				if !@yahooKeyStats["Float"].nil?
					@numShares = @yahooKeyStats["Float"].to_i
				elsif !@databaseValues["num_shares"].nil?
					@numShares = @databaseValues["num_shares"]
				else
					return @numShares = nil
				end
			else
				return true
			end
		end

		def get_free_cash_flow
			if @freeCashFlow.nil?
				if !@yahooKeyStats["OperatingCashFlow"]["content"].nil?
					@freeCashFlow = @yahooKeyStats["OperatingCashFlow"]["content"].to_f
				elsif !@databaseValues["free_cash_flow"].nil?
					@freeCashFlow = @databaseValues["free_cash_flow"]
				else
					return @freeCashFlow = nil
				end
			else
				return true
			end
		end

		def get_company_growth
			if @companyGrowth.nil?
				if !@quandlStockData["Expected Growth in Earnings Per Share"].nil?
					@companyGrowth = @quandlStockData["Expected Growth in Earnings Per Share"].to_f
				elsif !@databaseValues["earnings_growth"].nil?
					@companyGrowth = @databaseValues["earnings_growth"]
				else 
					@companyGrowth = nil
				end
			else
				return true
			end
		end

		def get_PE_ratio
			if @PE_ratio.nil?
				if !@quandlStockData["Trailing PE Ratio"].nil?
					@PE_ratio = @quandlStockData["Trailing PE Ratio"].to_f
				elsif !@databaseValues["PE_ratio"].nil?
					@PE_ratio = @databaseValues["PE_ratio"]
				else
					@PE_ratio = nil
				end
			else
				return true
			end
		end

		def get_assets
			if @netAssets.nil?
				if !@quandlStockData["Book Value of Assets"].nil?
					@netAssets = @quandlStockData["Book Value of Assets"].to_i * 1_000_000
				elsif !@databaseValues["assets"].nil?
					@netAssets = @databaseValues["assets"]
				else
					@netAssets = nil
				end
			else
				return true
			end
		end

		def get_beta
			if @regBeta.nil?
				if !@quandlStockData["3-Year Regression Beta"].nil?
					@regBeta = @quandlStockData["3-Year Regression Beta"].to_f
				elsif !@databaseValues["beta"].nil?
					@regBeta = @databaseValues["beta"]
				else
					@regBeta = nil
				end
			else 
				return true
			end
		end

		def get_debt
			if @totalDebt.nil?
				if !@quandlStockData["Total Debt"].nil?
					@totalDebt = @quandlStockData["Total Debt"].to_f * 1_000_000
				elsif !@databaseValues["beta"].nil?
					@totalDebt = @databaseValues["beta"]
				else
					@totalDebt = nil
				end
			else
				return true
			end
		end

		def get_tax
			if @taxRate.nil?
				if !@quandlStockData["Effective Tax Rate"].nil?
					@taxRate = @quandlStockData["Effective Tax Rate"].to_f
				elsif !@databaseValues["eff_tax_rate"].nil?
					@taxRate = @databaseValues["eff_tax_rate"]
				else
					@taxRate = nil
				end
			else
				return true
			end
		end
		
		def get_market_cap
			if @marketCap.nil?
				if !@quandlStockData["Market Capitalization"].nil?
					@marketCap = @quandlStockData["Market Capitalization"].to_i
				elsif !@databaseValues["mkt_cap"].nil?
					@marketCap = @databaseValues["mkt_cap"]
				else
					@marketCap = nil
				end
			else
				return true
			end
		end

		def get_Fiftyday_MA
			if @Fiftyday_MA.nil?
				!@yahooQuote["FiftydayMovingAverage"].nil? ? @Fiftyday_MA = @yahooQuote["FiftydayMovingAverage"].to_f : @Fiftyday_MA = nil
			else
				return true
			end
		end

		def get_50_MA_PRCT
			if @Fifty_MA_PRCT.nil?
				!@yahooQuote["PercentChangeFromFiftydayMovingAverage"].nil? ? @Fifty_MA_PRCT = (@yahooQuote["PercentChangeFromFiftydayMovingAverage"].to_f / 100) : @Fifty_MA_PRCT = nil
			else
				return true
			end
		end

		def get_250_MA_PRCT
			if @TwoFifty_MA_PRCT.nil?
				!@yahooQuote["PercentChangeFromTwoHundreddayMovingAverage"].nil? ? @TwoFifty_MA_PRCT = @yahooQuote["PercentChangeFromTwoHundreddayMovingAverage"].to_f : @TwoFifty_MA_PRCT = nil
			else
				return true
			end
		end

		def get_ask
			if @priceAsk.nil?
				!@yahooQuote["Ask"].nil? ? @priceAsk = @yahooQuote["Ask"].to_f : @priceAsk = nil
			else
				return true
			end
		end

		def get_bid
			if @priceBid.nil?
				!@yahooQuote["Bid"].nil? ? @priceBid = @yahooQuote["Bid"].to_f : @priceBid = nil
			else
				return true
			end
		end

		def get_low
			if @priceLow.nil?
				!@yahooQuote["DaysLow"].nil? ? @priceLow = @yahooQuote["DaysLow"].to_f : @priceLow = nil
			else
				return true
			end
		end

		def get_high
			if @priceHigh.nil?
				!@yahooQuote["DaysHigh"].nil? ? @priceHigh = @yahooQuote["DaysHigh"].to_f : @priceHigh = nil
			else
				return true
			end
		end

		def get_last
			if @priceLast.nil?
				!@yahooQuote["LastTradePriceOnly"].nil? ? @priceLast = @yahooQuote["LastTradePriceOnly"].to_f : @priceLast = nil
			else
				return true
			end
		end

		def get_bullish
			if @bullish.nil?
				!@quandlPsychData[1].nil? ? @bullish = @quandlPsychData[1].to_f : @bullish = nil
			else
				return true
			end
		end

		def get_bearish
			if @bearish.nil?
				!@quandlPsychData[2].nil? ? @bearish = @quandlPsychData[2].to_f : @bearish = nil
			else
				return true
			end
		end

		def get_riskFreeRate
			if @riskFreeRate.nil?
				@riskFreeRate = $financialConstant.get("riskFreeRate").to_f
			else
				return true
			end
		end

		def get_overnightDiscountRate
			if @overnightDiscountRate.nil?
				@overnightDiscountRate = $financialConstant.get("overnightDiscountRate").to_f
			else
				return true
			end
		end

		def get_hy_rate
			if @highYieldRate.nil?
				@highYieldRate = $financialConstant.get("highYieldBond").to_f
			else
				return true
			end
		end

		def get_ig_rate
			if @investGradeRate.nil?
				@investGradeRate = $financialConstant.get("investmentGradeBond").to_f
			else
				return true
			end
		end	

		def get_mktGrwthRateNSDQ
			if @gwthRateNSDQ.nil?
				@gwthRateNSDQ = ($financialConstant.get("marketGrowthRateNSDQ").to_f).round(4)
			else
				return true
			end
		end

		def get_mktGrwthRateNYSE
			if @gwthRateNYSE.nil?
				@gwthRateNYSE = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4)
			else 
				return true
			end
		end
		
		## ===============  Helper Variables  ========================


		# Current Stock Price = (Asking Price + Bid Price + Days Low Price + Days High Price + Last Trade Price) / 5
		def get_weighted_quote
			if @current_stock_price.nil?
				quote_array = [method(:get_ask).call, method(:get_bid).call, method(:get_low).call, method(:get_high).call, method(:get_last).call]
				@current_stock_price = quote_array.compact.reduce(:+) / quote_array.compact.count

				return true
			else
				return true
			end
		end

		def get_comparables
			if @sorted_comparables.nil?

				stock_mkt_cap = @marketCap

				our_stock = Stock.where(stock_ticker: self.stock_ticker).first
				!our_stock.sic_code.nil? ? @sic_code = our_stock.sic_code : @sic_code = StockInfo.where(ticker_sign: self.stock_ticker).first.sic_code
				stock_identifier = our_stock.id

				@rough_comparables = Stock.sector(stock_identifier, @sic_code)
				@sorted_comparables = @rough_comparables.where("? < mkt_cap < ?", stock_mkt_cap/5, stock_mkt_cap*5).all

				!@sorted_comparables.empty? ? (return true) : (return false)

			else
				return true
			end
		end

		def get_dividend_growth_rate
			if @dividend_growth_rate.nil? 
				@dividend_growth_rate = (@forwardDividendRate - @trailingDividendRate) / @trailingDividendRate

				!@dividend_growth_rate.nil? && !@dividend_growth_rate.nan? ? true : (return false)

			else
				return true
			end
		end

		def get_cost_of_equity_capm
			if @cost_of_equity_capm.nil?
				@cost_of_equity_capm = @riskFreeRate + @regBeta * (get_exchange - @riskFreeRate)

				return true
			else
				return true
			end
		end

		def get_cost_of_equity_wacc
			if @cost_of_equity_wacc.nil?
				total = @marketCap + @totalDebt
				@cost_of_equity_wacc = ((@marketCap) / (total) * @cost_of_equity_capm) + (((@totalDebt) / (total)) * @cost_of_debt * (1 - @taxRate))
			else
				return true
			end
		end

		def get_cost_of_debt
			if @TwoFifty_MA_PRCT < -15
				@cost_of_debt = @highYieldRate
			else
				@cost_of_debt = @investGradeRate
			end
		end
		

		def get_exchange
      if StockInfo.where(ticker_sign: self.stock_ticker).first.exchange == "NASDAQ"
       	return @gwthRateNSDQ
      else
        return @gwthRateNYSE 
      end
    end
	end

	class ModValue < Value

		def compute_share_value(risk_free_mod, market_growth_mod)

			if get_data

				@composite_share_value = 0
			  counter = 0

				get_PE_ratio && get_weighted_quote && get_market_cap && get_comparables ? (@composite_share_value += method(:get_PE_ratio_comparable).call; counter += 1 ) : (@composite_share_value += 0)

				get_assets && get_debt && get_num_shares ? (@composite_share_value += method(:get_net_asset_value).call; counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_riskFreeRate(risk_free_mod) && get_beta && get_mktGrwthRateNSDQ(market_growth_mod) && get_mktGrwthRateNYSE(market_growth_mod) && get_cost_of_equity_capm ? (@composite_share_value += method(:get_fcf_value_capm).call; counter += 1 ) : (@composite_share_value += 0)

				get_free_cash_flow && get_company_growth && get_num_shares && get_market_cap && get_debt && get_250_MA_PRCT && get_hy_rate && get_ig_rate && get_riskFreeRate(risk_free_mod) && get_beta && get_mktGrwthRateNSDQ(market_growth_mod) && get_mktGrwthRateNYSE(market_growth_mod) && get_tax && get_cost_of_equity_capm ? (@composite_share_value += method(:get_fcf_value_wacc).call; counter += 1 ) : (@composite_share_value += 0)

				get_forward_dividend_rate && get_trailing_dividend_rate && get_overnightDiscountRate && get_dividend_growth_rate ? (@composite_share_value += method(:get_dividend_value).call ; counter += 1 ) : (@composite_share_value += 0)

				get_Fiftyday_MA && get_50_MA_PRCT && get_bullish && get_bearish ? (@composite_share_value += method(:get_sentiment_value).call ; counter += 1 ) : (@composite_share_value += 0)

				@composite_share_value != 0 ? (@composite_share_value / counter) : (return false) 
			else 

				return false

			end
		end

		def get_riskFreeRate(risk_free_mod)
			if @riskFreeRate.nil?
				@riskFreeRate = $financialConstant.get("riskFreeRate").to_f * risk_free_mod
			else
				return true
			end
		end

		def get_mktGrwthRateNSDQ(market_growth_mod)
			if @gwthRateNSDQ.nil?
				@gwthRateNSDQ = ($financialConstant.get("marketGrowthRateNSDQ").to_f).round(4) * market_growth_mod
			else
				return true
			end
		end

		def get_mktGrwthRateNYSE(market_growth_mod)
			if @gwthRateNYSE.nil?
				@gwthRateNYSE = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4) * market_growth_mod
			else 
				return true
			end
		end

	end

end