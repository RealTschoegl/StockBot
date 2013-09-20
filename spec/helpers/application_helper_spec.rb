require "spec_helper"

describe ApplicationHelper do
  describe "#get_stock_prices" do
  	it "returns a string with a stock value" do
  		stock_symbol_name = "YHOO" 
      helper.get_stock_prices(stock_symbol_name).should be_a_kind_of(String)
      helper.get_stock_prices(stock_symbol_name).should_not be_nil
		end
  end
end