class TrimCompanies < ActiveRecord::Migration
  def change
  	remove_column :companies, :market_growth_rate
  	remove_column	:companies, :risk_free_rate
  	remove_column	:companies, :complete
  	remove_column	:companies, :capm_share_value
  	remove_column	:companies, :fcf_share_value
  	remove_column	:companies,	:cost_of_equity
  	remove_column	:companies, :beta
  	remove_column	:companies, :PE_ratio
  	remove_column	:companies, :num_shares
  	remove_column	:companies, :free_cash_flow
  end
end
