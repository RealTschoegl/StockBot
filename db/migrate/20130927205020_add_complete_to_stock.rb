class AddCompleteToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :complete, :boolean
  end
end
