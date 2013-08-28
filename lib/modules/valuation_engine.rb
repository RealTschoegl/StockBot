require 'yahoofinance'

module ValuationEngine

  class Value
    attr_accessor :company, :stock_ticker, :current_stock_price, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :rate_of_return, :fcf_share_value, :capm_share_value, :dividend_share_value, :composite_share_value

    class << self
      attr_accessor :risk_free_rate, :market_growth_rate, :years_horizon
    end

  	# These are the variables that the valuation uses
    @risk_free_rate = 0.0141 #5 year treasury yield at market
    @market_growth_rate = 0.2038 #S&P500 1 year growth rate
    @years_horizon = 10 # Hard coded for now as a year value

  	def initialize(submitted_stock)
      @stock_ticker = submitted_stock
      @current_stock_price = get_current_stock_price(submitted_stock)
      @free_cash_flow = Stock.where(:stock_ticker => submitted_stock).first.free_cash_flow
      @num_shares = Stock.where(:stock_ticker => submitted_stock).first.num_shares
      @PE_ratio = Stock.where(:stock_ticker => submitted_stock).first.free_cash_flow / 100
      @dividend_per_share = Stock.where(:stock_ticker => submitted_stock).first.dividend_per_share
      @dividend_growth_rate = Stock.where(:stock_ticker => submitted_stock).first.dividend_growth_rate
      @beta = Stock.where(:stock_ticker => submitted_stock).first.beta
      @cost_of_equity = 0
      @rate_of_return = 0
      @fcf_share_value = 0
      @capm_share_value = 0
      @dividend_share_value = 0
      @composite_share_value = 0
  	end

    # # This method is used to get the current stock price in the market
    def get_current_stock_price(stock_symbol_name)
      quote_type = YahooFinance::StandardQuote
      quote_symbol = stock_symbol_name
      YahooFinance::get_quotes(quote_type,quote_symbol) do |qt|
        return qt.lastTrade
      end
    end

    # This method is used to computer the StockBot "house" valuation
    def compute_stock_price
      self.get_complex_constants
      self.get_composite_share_value
      self.get_time_value_of_money

      puts @risk_free_rate
      puts @market_growth_rate
      puts @years_horizon

      return @composite_share_value

    end

    def get_complex_constants
      self.get_cost_of_equity
      self.get_rate_of_return
    end

    def get_cost_of_equity
      self.cost_of_equity =  self.class.risk_free_rate + self.beta * (self.class.market_growth_rate - self.class.risk_free_rate)
    end

    def get_fcf_share_value
      self.fcf_share_value = self.free_cash_flow / (self.cost_of_equity - self.PE_ratio)
      divide_by_num_shares
    end

    def get_capm_share_value
      self.capm_share_value = (self.cost_of_equity + 1) * self.class.years_horizon * self.current_stock_price
    end

    def get_rate_of_return
      self.rate_of_return = (self.dividend_per_share / self.current_stock_price) + self.dividend_growth_rate
    end

    def get_dividend_share_value
      self.dividend_share_value = self.dividend_per_share/(self.rate_of_return - self.dividend_growth_rate)
    end

    def get_composite_share_value
        if self.dividend_per_share == 0
          self.composite_share_value = (self.get_fcf_share_value + self.get_capm_share_value) / 2
        else
          self.composite_share_value = (self.get_fcf_share_value + self.get_dividend_share_value + self.get_capm_share_value) / 3
        end
    end

    def get_time_value_of_money
      self.composite_share_value = self.composite_share_value / ((1 + self.class.market_growth_rate)**self.class.years_horizon)
    end

    def divide_by_num_shares
      self.fcf_share_value = self.fcf_share_value / self.num_shares
    end 

  end

  class ModValue < Value
    @risk_free_rate = 0.0141 + 0.01
    @market_growth_rate = 0.2038 + 0.02
    @years_horizon = 10 + 5
  end

end