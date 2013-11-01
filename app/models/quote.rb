class Quote < ActiveRecord::Base
  attr_accessible :date, :price, :stock_symbol, :email

  before_create :set_date_time

  def set_date_time
    self.date = Time.now
  end
  
end
