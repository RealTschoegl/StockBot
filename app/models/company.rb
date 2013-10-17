class Company < ActiveRecord::Base
  attr_accessible :stock_ticker

  include FriendlyId
  friendly_id :stock_ticker, :use => [:slugged]

	def self.search(search)
    if search
      where('stock_ticker LIKE ? OR company_name LIKE ?', "%#{search}%", "%#{search}%").order('company_name ASC')
    else
      order('company_name ASC')
    end
  end

end
