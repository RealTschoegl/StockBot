class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|

      t.timestamps
    end
  end
end
