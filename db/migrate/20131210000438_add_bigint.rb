class AddBigint < ActiveRecord::Migration
  def change
  	change_column :stocks, :mkt_cap, :bigint
		change_column :stocks, :assets, :bigint
		change_column :stocks, :debt, :bigint
  end
end
