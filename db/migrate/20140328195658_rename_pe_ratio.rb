class RenamePeRatio < ActiveRecord::Migration
  def change
  	rename_column :stocks, :PE_ratio, :current_pe_ratio
  	rename_column :companies, :PE_Comparable_Valuation, :current_pe_comp
  end
end
