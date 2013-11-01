require 'spec_helper'

describe "quotes/new" do
  before(:each) do
    assign(:quote, stub_model(Quote,
      :price => 1.5,
      :stock_symbol => "MyString"
    ).as_new_record)
  end

  it "renders new quote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", quotes_path, "post" do
      assert_select "input#quote_price[name=?]", "quote[price]"
      assert_select "input#quote_stock_symbol[name=?]", "quote[stock_symbol]"
    end
  end
end
