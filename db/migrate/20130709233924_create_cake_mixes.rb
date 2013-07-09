class CreateCakeMixes < ActiveRecord::Migration
  def change
    create_table :cake_mixes do |t|
      t.string :StockSymbol

      t.timestamps
    end
  end
end
