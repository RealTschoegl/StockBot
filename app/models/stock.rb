class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :current_stock_price, :free_cash_flow, :num_shares, :PE_ratio, :beta, :cost_of_equity, :fcf_share_value, :capm_share_value, :composite_share_value  

  # Public: A method that gets a stock's from Quandl's API.

  # stock_symbol_to_get - String, the stock symbol of the stock that you want the data for
  # stock_proper_name -  String, the official name of the stock that you want the data for

  # Example

  #     Stock.find_stock("YHOO", "Yahoo, Inc.")
  #     # => true

  # Returns true or false
  def self.find_stock(stock_symbol_to_get, stock_proper_name)
		url = "http://www.quandl.com/api/v1/datasets/OFDP/DMDRN_#{stock_symbol_to_get}_ALLFINANCIALRATIOS.csv?auth_token=#{ENV['QUANDL_API_TOKEN']}"
		data_hash = SmarterCSV.process(open(url), options={:key_mapping => true, :strings_as_keys => true, :downcase_headers => true})
    Stock.save_stock(stock_symbol_to_get, stock_proper_name, data_hash)		
  end

  # Public: A method that saves the stock gathered from self.find_stock in the database.

  # stock_symbol_to_get - String, the stock symbol of the stock that you want the data for
  # stock_proper_name - String, the official name of the stock that you want the data for
  # data_hash - Hash, the data from the API in hash form

  # Example

  #     Stock.save_stock("YHOO", "Yahoo, Inc.", data_hash)
  #     # => true

  # Returns true or false
  def self.save_stock(stock_symbol_to_get, stock_proper_name, data_hash)
    c = Stock.new
    c.stock_ticker = stock_symbol_to_get
    c.company = stock_proper_name
    c.free_cash_flow = data_hash[0]["free_cash_flow_to_firm"]
    c.num_shares = data_hash[0]["number_of_shares_outstanding"]
    c.PE_ratio = data_hash[0]["current_pe_ratio"]
    c.beta = data_hash[0]["3-year_regression_beta"]
    c.save 
  end

end



	
