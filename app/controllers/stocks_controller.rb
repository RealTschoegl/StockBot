class StocksController < ApplicationController

  def index
    
  end

  def picker
  	@stock_proper_name = params[:stock_symbol]
    @stock_symbol_name = params[:stock_tbd]
  end

  def results
  	@mod_stock_name = params[:mod_stock_fullName]
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]
  end

end

