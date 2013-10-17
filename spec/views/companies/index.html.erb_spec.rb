require 'spec_helper'

describe "companies/index" do
  before(:each) do
    assign(:companies, [
      stub_model(Company,
        :stock_ticker => "Stock Ticker"
      ),
      stub_model(Company,
        :stock_ticker => "Stock Ticker"
      )
    ])
  end

  it "renders a list of companies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Stock Ticker".to_s, :count => 2
  end
end
