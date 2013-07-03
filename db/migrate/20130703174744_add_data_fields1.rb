class AddDataFields1 < ActiveRecord::Migration
  def change
    add_column :stocks, :company, :string
    add_column :stocks, :stock_ticker, :string
    add_column :stocks, :free_cash_flow, :integer
    add_column :stocks, :num_shares, :integer
    add_column :stocks, :PE_ratio, :float
    add_column :stocks, :dividend_per_share, :float
    add_column :stocks, :dividend_growth_rate, :float
    add_column :stocks, :beta, :float
    add_column :stocks, :cost_of_equity, :float
    add_column :stocks, :current_stock_price, :float
    add_column :stocks, :expected_share_value, :float
    add_column :stocks, :capm_share_value, :float
    add_column :stocks, :dividend_share_value, :float
    add_column :stocks, :composite_share_value, :float
  end
end
