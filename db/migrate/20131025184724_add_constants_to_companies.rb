class AddConstantsToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :risk_free_rate, :float
  	add_column :companies, :market_growth_rate, :float
  end
end
