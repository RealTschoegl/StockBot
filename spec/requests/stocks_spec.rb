require 'spec_helper'

describe "Stocks" do
  describe "GET /stocks" do
    it "gets a response from the front page" do
      visit '/stocks'
      current_path.should == stocks_path
      page.status_code.should == 200
    end

    it "enters a stock", :js => true do
    	visit '/stocks'
    	fill_in("stock_tbd", :with => 'MSFT', exact: true)
    	page.find(:css, "*[data-text='MSFT']").click
    	find_button('Submit').click
    	current_path.should == "/stocks/picker"
    end
  end
end

