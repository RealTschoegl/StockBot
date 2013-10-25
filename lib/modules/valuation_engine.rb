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

    # Public: Assigns the below attributes to the class. 
    class << self
      # Public: Gets/Sets the @risk_free_rate.
      attr_accessor :risk_free_rate
      # Public: Gets/Sets the @market_growth_rate.
      attr_accessor :market_growth_rate
      # Public: Gets/Sets the @years_horizon.
      attr_accessor :years_horizon
    end

  	# Public: A float value to four digits that represents the lowest possible borrowing value.  Here we use the 5 year treasury yield at market as that value.
    @risk_free_rate = ($financialConstant.get("riskFreeRate").to_f).round(4)
    # Public: A float value to four digits that represents the amount that the market grew in the previous year.  Here we use the S&P500 1 year growth rate.
    @market_growth_rate = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4)
    # Public: An integer value that represents the number of years from now that we would intend to sell the stock.
    @years_horizon = 10

    # Public: This method initializes a Value object with an instance variable value.
    #
    # submitted_stock - A String value that is the user submitted stock's stock symbol
    def initialize(submitted_stock)
      @stock_ticker = submitted_stock
  	end

    def name_stock
      @company = Stock.where(stock_ticker: self.stock_ticker).first.company
    end

    # Public: This method computes a stock price based on our valuation model. 
    #
    # Returns a Float value.
    def compute_stock_price
      self.get_present_value
      self.assign_company_values
      return (@composite_share_value).round(2)
    end

    # Public: This method assigns the free_cash_flow value for that stock, from the Stocks database, to the new Value object as an attribute. 
    #
    # Returns an Integer value
    def get_free_cash_flow
      @free_cash_flow = Stock.where(:stock_ticker => self.stock_ticker).first.free_cash_flow
    end

    # Public: This method assigns the num_shares value for that stock, from the Stocks database, to the new Value object as an attribute. 
    #
    # Returns an Integer value
    def get_num_shares
      @num_shares = Stock.where(:stock_ticker => self.stock_ticker).first.num_shares
    end

    # Public: This method assigns the PE_ratio value for that stock, from the Stocks database, to the new Value object as an attribute. It is divided here by 100 because it is used as a proxy for growth and therefore needs to be rendered as a percentage.
    #
    # Returns a Float value
    def get_PE_ratio
      @PE_ratio = Stock.where(:stock_ticker => self.stock_ticker).first.PE_ratio / 100
    end

    # Public: This method assigns the beta value for that stock, from the Stocks database, to the new Value object as an attribute. 
    #
    # Returns a Float value
    def get_beta
      @beta = Stock.where(:stock_ticker => self.stock_ticker).first.beta
    end

    # Public: This method takes in the stock symbol picked by the user and returns the last traded price of that stock.  It takes that stock price from Yahoo Finance's API.
    #
    # stock_symbol_name - A String value that is the user submitted stock's stock symbol
    #
    # Returns a Float value.
    def get_current_stock_price(stock_symbol_name)
      quote_type = YahooFinance::StandardQuote
      quote_symbol = stock_symbol_name
      YahooFinance::get_quotes(quote_type,quote_symbol) do |qt|
        @current_stock_price = qt.lastTrade
        return @current_stock_price
      end
    end

    # Public:  This method computes the cost of equity for the stock.
    #
    # Returns a Float value.
    def get_cost_of_equity
      @cost_of_equity = (self.class.risk_free_rate + self.get_beta * (self.class.market_growth_rate - self.class.risk_free_rate)).round(2)
    end

    # Public: This method computes the Free Cash Flow Method value per share of a stock.
    #
    # Returns a Float value.
    def get_fcf_share_value
      @fcf_share_value = ((self.get_free_cash_flow / (self.get_cost_of_equity - self.get_PE_ratio)) / self.get_num_shares).round(2)
    end

    # Public: This method computes the CAPM Method value per share of a stock.
    #
    # Returns a Float value.
    def get_capm_share_value
      @capm_share_value = ((self.cost_of_equity + 1) * self.class.years_horizon * self.get_current_stock_price(self.stock_ticker)).round(2)
    end

    # Public: This method aggregates the methods of valuing stocks into one single composite share value.
    #
    # Returns a Float value.
    def get_composite_share_value
      @composite_share_value = ((self.get_fcf_share_value + self.get_capm_share_value) / 2).round(2)
    end

    # Public: This method accounts for time value to get the present value of the stock.
    #
    # Returns a Float value.
    def get_present_value
      self.composite_share_value = (self.get_composite_share_value / ((1 + ValuationEngine::Constants.get_exchange(self.stock_ticker))**self.class.years_horizon)).round(2)
    end

    # Public: This method creates a new entry in the Company database table with the data produced by the compute stock price method.
    # 
    # Returns true or false  
    def assign_company_values
      if Company.where(:stock_ticker => self.stock_ticker).empty?
        c = Company.new
        c.industry = StockInfo.where(ticker_sign: self.stock_ticker).first.industry
        c.sic_code = StockInfo.where(ticker_sign: self.stock_ticker).first.sic_code
        c.exchange = StockInfo.where(ticker_sign: self.stock_ticker).first.exchange
        c.risk_free_rate = self.class.risk_free_rate
        c.market_growth_rate = self.class.market_growth_rate
        c.stock_ticker = self.stock_ticker
        c.company_name = self.name_stock
        c.current_stock_price = self.current_stock_price
        c.free_cash_flow = self.free_cash_flow
        c.num_shares = self.num_shares
        c.PE_ratio = self.PE_ratio
        c.beta = self.beta
        c.cost_of_equity = self.cost_of_equity
        c.fcf_share_value = self.fcf_share_value
        c.capm_share_value = self.capm_share_value
        c.composite_share_value = self.composite_share_value
        c.complete = true
        c.save
      else
        b = Company.where(:stock_ticker => self.stock_ticker).first
        b.risk_free_rate = ((self.class.risk_free_rate).to_f).round(4)
        b.market_growth_rate = ((self.class.market_growth_rate).to_f).round(4)
        b.current_stock_price = self.current_stock_price
        b.free_cash_flow = self.free_cash_flow
        b.num_shares = self.num_shares
        b.PE_ratio = self.PE_ratio
        b.beta = self.beta
        b.cost_of_equity = self.cost_of_equity
        b.fcf_share_value = self.fcf_share_value
        b.capm_share_value = self.capm_share_value
        b.composite_share_value = self.composite_share_value
        b.complete = true
        b.save
      end
    end

  end

  # Public: A class that generates a customized stock valuation using methods inherited from the Value class and user input.
  #
  # Examples
  #
  #   ValuationEngine::ModValue.new(params[:mod_stock_fullSymbol])
  #   # => #<ValuationEngine::ModValue:0x007fcbc71000c8 @stock_ticker="MSFT", @current_stock_price=33.4, @free_cash_flow=31626, @num_shares=8350, @PE_ratio=316, @dividend_per_share=0.92, @dividend_growth_rate=0.028, @beta=1.1, @cost_of_equity=0, @rate_of_return=0, @fcf_share_value=0, @capm_share_value=0, @dividend_share_value=0, @composite_share_value=0>
  class ModValue < Value

    # Public: A float value to four digits that represents the lowest possible borrowing value.  Here we use the 5 year treasury yield at market as that value.
    @risk_free_rate = ($financialConstant.get("riskFreeRate").to_f).round(4)
    # Public: A float value to four digits that represents the amount that the market grew in the previous year.  Here we use the S&P500 1 year growth rate.
    @market_growth_rate = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4)
    # Public: An integer value that represents the number of years from now that we would intend to sell the stock.
    @years_horizon = 10

    def compute_stock_price
      self.get_present_value
      return (@composite_share_value).round(2)
    end

  end

  class Constants

    def self.get_exchange(stock_ticker)
      if StockInfo.where(ticker_sign: stock_ticker).first.exchange == "NASDAQ"
        exchange_growth_rate = ($financialConstant.get("marketGrowthRateNSDQ").to_f).round(4)
        ValuationEngine::Value.market_growth_rate = exchange_growth_rate
        ValuationEngine::ModValue.market_growth_rate = exchange_growth_rate
        return exchange_growth_rate
      else
        exchange_growth_rate = ($financialConstant.get("marketGrowthRateNYSE").to_f).round(4)
        ValuationEngine::Value.market_growth_rate = exchange_growth_rate
        ValuationEngine::ModValue.market_growth_rate = exchange_growth_rate
        return exchange_growth_rate
      end
    end

  end

end
