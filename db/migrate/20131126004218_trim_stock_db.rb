class TrimStockDb < ActiveRecord::Migration
  def change
  	remove_column :stocks, :current_stock_price
  	remove_column	:stocks, :cost_of_equity_CAPM
  	remove_column	:stocks, :fcf_share_value
  	remove_column	:stocks, :capm_share_value
  	remove_column	:stocks, :composite_share_value
  	remove_column	:stocks, :complete
  	remove_column	:stocks, :cost_of_equity_WACC
  	remove_column	:stocks, :cost_of_debt
  	remove_column	:stocks, :div_growth_rate
  end

end
