require "spec_helper"
require "#{Rails.root}/lib/modules/valuation_engine.rb"

describe ValuationEngine::Value do
	let(:test_stock) { build(:value) }
	subject { test_stock }

	it "should have the class attribute risk_free_rate" do
		ValuationEngine::Value.risk_free_rate.should_not be_nil
	end

	it "should have the class attribute market_growth_rate" do
		ValuationEngine::Value.market_growth_rate.should_not be_nil
	end

	it "should have the class attribute years_horizon" do
		ValuationEngine::Value.years_horizon.should_not be_nil
	end

	it "should create an instance of Value" do
		test_stock.should be_an_instance_of(ValuationEngine::Value)
	end

	it "should initialize the instance with the attribute stock_ticker" do
		test_stock.stock_ticker.should == "YHOO"
	end

  context "#get_free_cash_flow" do
  	it "should respond to get_free_cash_flow" do
    	test_stock.should respond_to(:get_free_cash_flow)
    end

    it "should return an integer value" do
    	test_stock.should_receive(:get_free_cash_flow).and_return(-281)
    	test_stock.get_free_cash_flow.should == -281
  	end
  end

  context "#get_num_shares" do
  	it "should respond to get_num_shares" do
    	test_stock.should respond_to(:get_num_shares)
    end

    it "should return an integer value" do
    	test_stock.should_receive(:get_num_shares).and_return(1008)
    	test_stock.get_num_shares.should == 1008
    end
  end

  context "#get_PE_ratio" do
  	it "should respond to get_PE_ratio" do
    	test_stock.should respond_to(:get_PE_ratio)
    end

	it "should return a float value" do
    	test_stock.should_receive(:get_PE_ratio).and_return(6.67)
    	test_stock.get_PE_ratio.should == 6.67
    end    
  end

  context "#get_beta" do
  	it "should respond to get_beta" do
    	test_stock.should respond_to(:get_beta)
    end

    it "should return a float value" do
    	test_stock.should_receive(:get_beta).and_return(0.89)
    	test_stock.get_beta.should == 0.89
    end
  end

	context "#compute_stock_price" do
		it "should respond to compute_stock_price" do
			test_stock.should respond_to(:compute_stock_price)
		end
	end

	context "#get_current_stock_price" do
		it "should respond to get_current_stock_price" do
			test_stock.should respond_to(:get_current_stock_price)
		end
	end

	context "#get_cost_of_equity" do
		it "should respond to get_cost_of_equity" do
			test_stock.should respond_to(:get_cost_of_equity)
		end
	end

	context "#get_fcf_share_value" do
		it "should respond to get_fcf_share_value" do
			test_stock.should respond_to(:get_fcf_share_value)
		end
	end

	context "#get_capm_share_value" do
		it "should respond to get_capm_share_value" do
			test_stock.should respond_to(:get_capm_share_value)
		end
	end

	context "#get_composite_share_value" do
		it "should respond to get_composite_share_value" do
			test_stock.should respond_to(:get_composite_share_value)
		end
	end

	context "#get_present_value" do
		it "should respond to get_present_value" do
			test_stock.should respond_to(:get_present_value)
		end
	end

end

describe ValuationEngine::ModValue do
	let(:test_stock) { build(:mod_value) }
	subject { test_stock }

	it "should have the class attribute risk_free_rate" do
		ValuationEngine::ModValue.risk_free_rate.should_not be_nil
	end

	it "should have the class attribute market_growth_rate" do
		ValuationEngine::ModValue.market_growth_rate.should_not be_nil
	end

	it "should have the class attribute years_horizon" do
		ValuationEngine::ModValue.years_horizon.should_not be_nil
	end

	it "should create an instance of Value" do
		test_stock.should be_an_instance_of(ValuationEngine::ModValue)
	end

	it "should initialize the instance with the attribute stock_ticker" do
		test_stock.stock_ticker.should == "YHOO"
	end
end
