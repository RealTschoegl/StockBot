class NewValMod < ActiveRecord::Migration
  def change
  	add_column :stocks, :mkt_cap, :integer
		add_column :stocks, :assets, :integer
		add_column :stocks, :debt, :integer
		add_column :stocks, :earnings_growth, :float
		add_column :stocks, :forw_div_rate, :float
		add_column :stocks, :trail_div_rate, :float
		add_column :stocks, :eff_tax_rate, :float
		add_column :stocks, :cost_of_equity_WACC, :float
		add_column :stocks, :cost_of_debt, :float
		add_column :stocks, :div_growth_rate, :float
		rename_column :stocks, :cost_of_equity, :cost_of_equity_CAPM
  end
end
