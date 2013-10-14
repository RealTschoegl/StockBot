class Company < ActiveRecord::Base
  attr_accessible :stock_ticker

  include FriendlyId
  friendly_id :stock_ticker, :use => [:slugged]

end
