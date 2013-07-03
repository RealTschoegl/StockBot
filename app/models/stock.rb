class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :free_cash_flow, :num_shares, :PE_ratio, :dividend_per_share, :dividend_growth_rate, :beta, :cost_of_equity, :current_stock_price, :expected_share_value, :capm_share_value, :dividend_share_value, :composite_share_value
end
