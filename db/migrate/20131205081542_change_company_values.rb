class ChangeCompanyValues < ActiveRecord::Migration
  def change
  	add_column :companies, :PE_Comparable_Valuation, :float
		add_column :companies, :NAV_Valuation, :float
		add_column :companies, :CAPM_Valuation, :float
		add_column :companies, :WACC_Valuation, :float
		add_column :companies, :Dividend_Valuation, :float
		add_column :companies, :Sentiment_Valuation, :float
  end
end
