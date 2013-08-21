class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :current_stock_price, :expected_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

  	require 'yahoofinance' # Needed for current price

    # These are the variables that the valuation uses
    @@risk_free_rate = 0.0141 #5 year treasury yield at market
    @@market_growth_rate = 0.2038 #S&P500 1 year growth rate
    @@years_horizon = 10

      @stock_ticker_symbol = ""
      @current_stock_price = 0
      @free_cash_flow = 0
      @num_shares = 0
      @PE_ratio = 0
      @dividend_per_share = 0
      @dividend_growth_rate = 0
      @beta = 0
      @cost_of_equity = 0
      @rate_of_return = 0
      @fcf_share_value = 0
      @capm_share_value = 0
      @dividend_share_value = 0
      @composite_share_value = 0


    # This method is used to computer the StockBot "house" valuation
    def self.compute_stock_price(stock_ticker_symbol)
      Stock.get_complex_constants(stock_ticker_symbol)
      Stock.get_composite_share_value
      Stock.get_time_value_of_money

      return @composite_share_value
    end

    def self.get_complex_constants(stock_symbol_name)
      Stock.get_cost_of_equity
      Stock.get_current_stock_price
      Stock.get_rate_of_return
    end

    # This method is used to get the name of the stock that the user submits and match it to the name of a stock in our database
    def self.get_stock_ticker_symbol(stock_symbol_name)
      @stock_ticker_symbol = Stock.where(:stock_ticker => stock_symbol_name).first.stock_ticker
    end

    # This method is used to get the current stock price in the market
    def self.get_current_stock_price(stock_symbol_name)
      quote_type = YahooFinance::StandardQuote
      quote_symbol = stock_symbol_name
      YahooFinance::get_quotes( quote_type, quote_symbol ) do |qt|
        @current_stock_price = qt.lastTrade
      end
    end 

    def self.get_free_cash_flow(stock_symbol_name)
      @free_cash_flow = Stock.where(:stock_ticker => stock_symbol_name).first.free_cash_flow
    end

    def self.get_num_shares(stock_symbol_name)
      @num_shares = Stock.where(:stock_ticker => stock_symbol_name).first.num_shares
    end

    def self.get_PE_ratio(stock_symbol_name)
      @PE_ratio = Stock.where(:stock_ticker => stock_symbol_name).first.free_cash_flow / 100
    end

    def self.get_dividend_per_share(stock_symbol_name)
      @dividend_per_share = Stock.where(:stock_ticker => stock_symbol_name).first.dividend_per_share
    end

    def self.get_dividend_growth_rate(stock_symbol_name)
      @dividend_growth_rate = Stock.where(:stock_ticker => stock_symbol_name).first.dividend_growth_rate
    end

    def self.get_beta(stock_symbol_name)
      @beta = Stock.where(:stock_ticker => stock_symbol_name).first.beta
    end

    def self.get_cost_of_equity
      @cost_of_equity =  @@risk_free_rate + @beta * (@@market_growth_rate - @@risk_free_rate)
    end

    def self.get_fcf_share_value
      @fcf_share_value = @free_cash_flow / (@cost_of_equity - @PE_ratio)
    end

    def self.get_capm_share_value
      @capm_share_value = (@cost_of_equity + 1) * @@years_horizon * @current_stock_price
    end

    def self.get_rate_of_return
      @rate_of_return = (@dividend_per_share / @current_stock_price) + @dividend_growth_rate
    end

    def self.get_dividend_share_value
      @dividend_share_value = @dividend_per_share/(@rate_of_return - @dividend_growth_rate)
    end

    def self.get_composite_share_value
        if @dividend_per_share == 0
          @composite_share_value = (@fcf_share_value + @capm_share_value) / 2
        else
          @composite_share_value = (@fcf_share_value + @dividend_share_value + @capm_share_value) / 3
        end
    end

    def self.get_time_value_of_money
      @composite_share_value = @composite_share_value / ((1 + @@market_growth_rate)**@@years_horizon)
    end

    def self.divide_by_num_shares
      @fcf_share_value = @fcf_share_value / @num_shares
    end
	
end

