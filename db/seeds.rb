# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Stock.create(
    :company => "Google",
    :stock_ticker => "GOOG",
    :free_cash_flow => 16500,
    :num_shares => 332, 
    :PE_ratio => 25.8,
    :dividend_per_share => 0, #Forward Annual Dividend Rate
    :dividend_growth_rate => 0, #Forward Annual Dividend Yield
    :beta => 1.19,
    :cost_of_equity => 0,
    :current_stock_price => 0,
    :expected_share_value => 0,
    :capm_share_value => 0,
    :dividend_share_value => 0,
    :composite_share_value => 0
    )
Stock.create(
    :company => "Microsoft",
    :stock_ticker => "MSFT",
    :free_cash_flow => 31626,
    :num_shares => 8350,
    :PE_ratio => 17.5,
    :dividend_per_share => 0.92,
    :dividend_growth_rate => 0.028,
    :beta => 1.10,
    :cost_of_equity => 0,
    :current_stock_price => 0,
    :expected_share_value => 0, 
    :capm_share_value => 0,
    :dividend_share_value => 0,
    :composite_share_value => 0
    )
Stock.create( 
    :company => "Yahoo",
    :stock_ticker => "YHOO",
    :free_cash_flow => -281,
    :num_shares => 1008,
    :PE_ratio => 6.67,
    :dividend_per_share => 0,
    :dividend_growth_rate => 0,
    :beta => 0.89,
    :cost_of_equity => 0,
    :current_stock_price => 0,
    :expected_share_value => 0,
    :capm_share_value => 0,
    :dividend_share_value => 0,
    :composite_share_value => 0
    )
Stock.create(
    :company => "Facebook",
    :stock_ticker => "FB",
    :free_cash_flow => 1612,
    :num_shares => 2420,
    :PE_ratio => 872,
    :dividend_per_share => 0,
    :dividend_growth_rate => 0,
    :beta => 1.33,
    :cost_of_equity => 0,
    :current_stock_price => 10,
    :expected_share_value => 0,
    :capm_share_value => 0,
    :dividend_share_value => 0,
    :composite_share_value => 0
    )