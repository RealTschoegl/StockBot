class AddExchange < ActiveRecord::Migration
  def change
  	add_column :stocks, :exchange, :string
  	add_column :companies, :exchange, :string
  end
end
