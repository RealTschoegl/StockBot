class StocksController < ApplicationController

  def index
    
  end

  def picker
     @stock_proper_name = params[:stock_symbol]
     @stock_symbol_name = params[:stock_tbd]
  end

  def results

  end

end

