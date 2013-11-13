class StockInfo < ActiveRecord::Base
  attr_accessible :ticker_sign, :quandl_code,	:proper_name, :industry, :exchange, :sic_code

    scope :sector, ->(code) { where(:sic_code => code ) }
  
end
