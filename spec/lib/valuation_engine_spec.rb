require "spec_helper"
require "#{Rails.root}/lib/modules/valuation_engine.rb"

describe ValuationEngine::Value do
	it "creates our stock valuation" do
		test_stock = ValuationEngine::Value.new("YHOO")
		test_stock.stock_ticker.should == "YHOO"
	end

	context "#get_current_stock_price" do

	end

	context "#compute_stock_price" do

	end

	context "#get_cost_of_equity" do

	end

	context "#get_fcf_share_value" do

	end

	context "#get_capm_share_value" do

	end

	context "#get_rate_of_return" do

	end

	context "#get_dividend_share_value" do

	end

	context "#get_composite_share_value" do

	end

	context "#get_present_value" do

	end

	context "#divide_by_num_shares" do

	end
end

describe ValuationEngine::ModValue do
	it "creates the user's stock valuation" do

	end

	it "inherits from the Value class" do
		# ValuationEngine::ModValue.should be_kind_of(ValuationEngine::Value)
	end

end