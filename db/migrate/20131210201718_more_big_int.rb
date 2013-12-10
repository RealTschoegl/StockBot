class MoreBigInt < ActiveRecord::Migration
  def change
  	change_column :stocks, :mkt_cap, :bigint, :limit => 8
		change_column :stocks, :assets, :bigint, :limit => 8
		change_column :stocks, :debt, :bigint, :limit => 8
		change_column :stocks, :free_cash_flow, :bigint, :limit => 8
    change_column :stocks, :num_shares, :bigint, :limit => 8
  end
end
