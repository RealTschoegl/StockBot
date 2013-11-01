class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :price
      t.datetime :date
      t.string :stock_symbol

      t.timestamps
    end
  end
end
