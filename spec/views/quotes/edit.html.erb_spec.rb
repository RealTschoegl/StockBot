require 'spec_helper'

describe "quotes/edit" do
  before(:each) do
    @quote = assign(:quote, stub_model(Quote,
      :price => 1.5,
      :stock_symbol => "MyString"
    ))
  end

  it "renders the edit quote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", quote_path(@quote), "post" do
      assert_select "input#quote_price[name=?]", "quote[price]"
      assert_select "input#quote_stock_symbol[name=?]", "quote[stock_symbol]"
    end
  end
end
