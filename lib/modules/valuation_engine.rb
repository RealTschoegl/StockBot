require 'yahoofinance'

# Public - Contains methods that, when combined, can be used to value an inputed stock.
#
# Examples
#
#   ValuationEngine::Value.years_horizon
#   # => 10
#
#   ValuationEngine::ModValue.years_horizon
#   # => nil

module ValuationEngine

  # Public: 
  #
  # Examples
  #
  #   ValuationEngine::Value.new(params[:stock_tbd])
  #   # => #<ValuationEngine::Value:0x007fcbc2d77590 @stock_ticker="MSFT", @current_stock_price=33.4, @free_cash_flow=31626, @num_shares=8350, @PE_ratio=316, @dividend_per_share=0.92, @dividend_growth_rate=0.028, @beta=1.1, @cost_of_equity=0, @rate_of_return=0, @fcf_share_value=0, @capm_share_value=0, @dividend_share_value=0, @composite_share_value=0>

  class Value
    # Public: Gets/Sets the String name of the stock's DBA name.
    attr_accessor :company
    # Public: Gets/Sets the String name of the stock's ticker symbol.
    attr_accessor :stock_ticker
    # Public: Gets/Sets the Float value of the stock's last traded price per share.
    attr_accessor :current_stock_price
    # Public: Gets/Sets the Integer value of the stock's free cash flow.
    attr_accessor :free_cash_flow
    # Public: Gets/Sets the Integer value of the stock's number of public shares.
    attr_accessor :num_shares
    # Public: Gets/Sets the Float value of the stock's price-to-equity ratio.
    attr_accessor :PE_ratio
    # Public: Gets/Sets the Float value of the stock's dividend payout per share.
    attr_accessor :dividend_per_share
    # Public: Gets/Sets the Float value of the stock's dividend growth rate this year.
    attr_accessor :dividend_growth_rate
    # Public: Gets/Sets the Float value of the stock's performance versus the broader market.
    attr_accessor :beta
    # Public: Gets/Sets the Float value of the stock's cost of equity.
    attr_accessor :cost_of_equity
    # Public: Gets/Sets the Float value of the stock's rate of return.
    attr_accessor :rate_of_return
    # Public: Gets/Sets the Float value of the stock's free cash flow value per share.
    attr_accessor :fcf_share_value
    # Public: Gets/Sets the Float value of the stock's CAPM value per share.
    attr_accessor :capm_share_value
    # Public: Gets/Sets the Float value of the stock's rate of return.
    attr_accessor :dividend_share_value
    # Public: Gets/Sets the Float value of the stock's value as a composite of the fcf_share_value, capm_share_value, and dividend_share_value.
    attr_accessor :composite_share_value

    class << self
      # Public: Gets/Sets the @risk_free_rate.
      attr_accessor :risk_free_rate
      # Public: Gets/Sets the @market_growth_rate.
      attr_accessor :market_growth_rate
      # Public: Gets/Sets the @years_horizon.
      attr_accessor :years_horizon
    end

  	# Public: A float value to four digits that represents the lowest possible borrowing value.  Here we use the 5 year treasury yield at market as that value.
    @risk_free_rate = 0.0141 
    # Public: A float value to four digits that represents the amount that the market grew in the previous year.  Here we use the S&P500 1 year growth rate.
    @market_growth_rate = 0.2038 
    # Public: An integer value that represents the number of years from now that we would intend to sell the stock.
    @years_horizon = 10

  	def initialize(submitted_stock)
      @stock_ticker = submitted_stock
      @current_stock_price = get_current_stock_price(submitted_stock)
      @free_cash_flow = Stock.where(:stock_ticker => submitted_stock).first.free_cash_flow
      @num_shares = Stock.where(:stock_ticker => submitted_stock).first.num_shares
      @PE_ratio = Stock.where(:stock_ticker => submitted_stock).first.free_cash_flow / 100
      @dividend_per_share = Stock.where(:stock_ticker => submitted_stock).first.dividend_per_share
      @dividend_growth_rate = Stock.where(:stock_ticker => submitted_stock).first.dividend_growth_rate
      @beta = Stock.where(:stock_ticker => submitted_stock).first.beta
      @cost_of_equity = self.get_cost_of_equity
      @rate_of_return = self.get_rate_of_return
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
      self.get_present_value

      return (@composite_share_value).round(2)

    end

    def get_cost_of_equity
      self.cost_of_equity =  (self.class.risk_free_rate + self.beta * (self.class.market_growth_rate - self.class.risk_free_rate)).round(2)
    end

    def get_fcf_share_value
      self.fcf_share_value = (self.free_cash_flow / (self.cost_of_equity - self.PE_ratio)).round(2)
      divide_by_num_shares
    end

    def get_capm_share_value
      self.capm_share_value = ((self.cost_of_equity + 1) * self.class.years_horizon * self.current_stock_price).round(2)
    end

    def get_rate_of_return
      self.rate_of_return = ((self.dividend_per_share / self.current_stock_price) + self.dividend_growth_rate).round(2)
    end

    def get_dividend_share_value
      self.dividend_share_value = (self.dividend_per_share/(self.rate_of_return - self.dividend_growth_rate)).round(2)
    end

    def get_composite_share_value
        if self.dividend_per_share == 0
          self.composite_share_value = ((self.get_fcf_share_value + self.get_capm_share_value) / 2).round(2)
        else
          self.composite_share_value = ((self.get_fcf_share_value + self.get_dividend_share_value + self.get_capm_share_value) / 3).round(2)
        end
    end

    def get_present_value
      self.composite_share_value = (self.get_composite_share_value / ((1 + self.class.market_growth_rate)**self.class.years_horizon)).round(2)
    end

    def divide_by_num_shares
      self.fcf_share_value = (self.fcf_share_value / self.num_shares).round(2)
    end 

  end

  # Public: A class that generates a customized stock valuation using methods inherited from the Value class and user input.
  #
  # Examples
  #
  #   ValuationEngine::ModValue.new(params[:mod_stock_fullSymbol])
  #   # => #<ValuationEngine::ModValue:0x007fcbc71000c8 @stock_ticker="MSFT", @current_stock_price=33.4, @free_cash_flow=31626, @num_shares=8350, @PE_ratio=316, @dividend_per_share=0.92, @dividend_growth_rate=0.028, @beta=1.1, @cost_of_equity=0, @rate_of_return=0, @fcf_share_value=0, @capm_share_value=0, @dividend_share_value=0, @composite_share_value=0> 
  class ModValue < Value
    
  end

end