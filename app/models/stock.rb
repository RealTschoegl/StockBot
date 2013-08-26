class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :current_stock_price, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :rate_of_return, :fcf_share_value, :capm_share_value, :dividend_share_value, :composite_share_value  



end


  # This method is used to computer the StockBot "house" valuation
  # def self.compute_stock_price(stock_ticker_symbol)
  #   Stock.get_complex_constants(stock_ticker_symbol)
  #   Stock.get_composite_share_value
  #   Stock.get_time_value_of_money

  #   return @composite_share_value
  # end

  # def self.get_complex_constants(stock_symbol_name)
  #   Stock.get_cost_of_equity
  #   Stock.get_current_stock_price(stock_symbol_name)
  #   Stock.get_rate_of_return
  # end

  

  # def self.get_cost_of_equity
  #   @cost_of_equity =  @@risk_free_rate + @beta * (@@market_growth_rate - @@risk_free_rate)
  # end

  # def self.get_fcf_share_value
  #   @fcf_share_value = @free_cash_flow / (@cost_of_equity - @PE_ratio)
  #   Stock.divide_by_num_shares
  # end

  # def self.get_capm_share_value
  #   @capm_share_value = (@cost_of_equity + 1) * @@years_horizon * @current_stock_price
  # end

  # def self.get_rate_of_return
  #   @rate_of_return = (@dividend_per_share / @current_stock_price) + @dividend_growth_rate
  # end

  # def self.get_dividend_share_value
  #   @dividend_share_value = @dividend_per_share/(@rate_of_return - @dividend_growth_rate)
  # end

  # def self.get_composite_share_value
  #     if @dividend_per_share == 0
  #       @composite_share_value = (@fcf_share_value + @capm_share_value) / 2
  #     else
  #       @composite_share_value = (@fcf_share_value + @dividend_share_value + @capm_share_value) / 3
  #     end
  # end

  # def self.get_time_value_of_money
  #   @composite_share_value = @composite_share_value / ((1 + @@market_growth_rate)**@@years_horizon)
  # end

  # def self.divide_by_num_shares
  #   @fcf_share_value = @fcf_share_value / @num_shares
  # end
	
