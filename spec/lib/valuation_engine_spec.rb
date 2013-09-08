require "spec_helper"
require "#{Rails.root}/lib/modules/valuation_engine.rb"

describe ValuationEngine::Value do
	it "creates our stock valuation" do
		test_stock = ValuationEngine::Value.new("YHOO")
		test_stock.stock_ticker.should == "YHOO"
	end
end

describe ValuationEngine::ModValue do
	it "creates the user's stock valuation" do

	end

	it "inherits from the Value class" do
		# ValuationEngine::ModValue.should be_kind_of(ValuationEngine::Value)
	end
end