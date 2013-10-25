class AddIndustry < ActiveRecord::Migration
  def change
  	add_column :stocks, :industry, :string
  	add_column :stocks, :sic_code, :integer
  	

  	add_column :companies, :industry, :string
  	add_column :companies, :sic_code, :integer
  end
end
