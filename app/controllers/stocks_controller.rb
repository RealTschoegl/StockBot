class StocksController < ApplicationController

  def index
    
  end

  def picker
    require "#{Rails.root}/lib/modules/valuation_engine.rb"
    
  	@stock_proper_name = params[:stock_symbol]
    @stock_symbol_name = params[:stock_tbd]
    picked_stock = ValuationEngine::Value.new(params[:stock_tbd])
    @our_stock_price = picked_stock.get_stock_price
  end

  def results
    require "#{Rails.root}/lib/modules/valuation_engine.rb"

  	@mod_stock_name = params[:mod_stock_fullName]
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]
  	@mod_stock_value = ValuationEngine::Value.final_stock_value(params[:mod_stock_fullSymbol])
  end

end

