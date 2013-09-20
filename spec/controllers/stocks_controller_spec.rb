require "spec_helper"

describe StocksController do
	describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET picker" do
    it "assigns @stock_proper_name" do
      get :picker, :stock_symbol => "Yahoo, Inc."
      controller.params[:stock_symbol].should_not be_nil
    end

    it "assigns @stock_symbol_name" do
      get :picker, :stock_tbd => "YHOO"
      controller.params[:stock_tbd].should_not be_nil
    end

  	it "assigns @our_stock_price" do
      pending
  	end
  end

  describe "GET results" do
    it "assigns @mod_stock_name" do
      pending
    end

    it "assigns @mod_stock_symbol" do
      pending
    end
  end
end