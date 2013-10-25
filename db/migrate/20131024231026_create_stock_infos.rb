class CreateStockInfos < ActiveRecord::Migration
  def change
    create_table :stock_infos do |t|
      t.string 	:ticker_sign
      t.string 	:quandl_code
      t.string 	:proper_name
      t.string 	:industry
      t.string	:exchange
      t.integer	:sic_code
      t.timestamps
    end
  end
end
