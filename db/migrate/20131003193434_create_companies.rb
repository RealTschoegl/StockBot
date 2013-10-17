class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.timestamps

      t.string :stock_ticker
    end
  end
end
