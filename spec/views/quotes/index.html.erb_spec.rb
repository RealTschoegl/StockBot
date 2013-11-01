require 'spec_helper'

describe "quotes/index" do
  before(:each) do
    assign(:quotes, [
      stub_model(Quote,
        :price => 1.5,
        :stock_symbol => "Stock Symbol"
      ),
      stub_model(Quote,
        :price => 1.5,
        :stock_symbol => "Stock Symbol"
      )
    ])
  end

  it "renders a list of quotes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Stock Symbol".to_s, :count => 2
  end
end
