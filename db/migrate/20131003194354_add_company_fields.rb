class AddCompanyFields < ActiveRecord::Migration
  def change
  	add_column :companies, :company_name, :string
    add_column :companies, :current_stock_price, :float
    add_column :companies, :free_cash_flow, :integer
    add_column :companies, :num_shares, :integer
    add_column :companies, :PE_ratio, :float
    add_column :companies, :beta, :float
    add_column :companies, :cost_of_equity, :float
    add_column :companies, :fcf_share_value, :float
    add_column :companies, :capm_share_value, :float
    add_column :companies, :composite_share_value, :float
    add_column :companies, :complete, :boolean
  end
end
