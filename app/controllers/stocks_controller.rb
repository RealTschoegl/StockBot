class StocksController < ApplicationController

  def index
    
  end

  def picker
  	@stock_proper_name = params[:stock_symbol]
    @stock_symbol_name = params[:stock_tbd]
    @our_stock_price = Stock.get_stock_price(params[:stock_tbd])
  end

  def results
    require "#{Rails.root}/lib/modules/valuation_engine.rb"

  	@mod_stock_name = params[:mod_stock_fullName]
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]
  	@mod_stock_value = ValuationEngine::Value.final_stock_value(params[:mod_stock_fullSymbol])
  end

end

