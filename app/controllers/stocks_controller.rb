class StocksController < ApplicationController

  # Public: The front page of the site where the user inputs the stock. 
  def index
    
  end

  # Public: The page where the user makes their customized choices to be inputed into the final valuation.
  def picker

    # Public: This calls the module containing the Value class.
    require "#{Rails.root}/lib/modules/valuation_generator.rb"
    
    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @stock_proper_name
  	@stock_proper_name = params[:stock_symbol]

    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @stock_symbol_name
    @stock_symbol_name = params[:stock_tbd]

    # Public: Calls the serve_stock method so it can determine if the stock exists in the database and can be used in a valuation. 
    @picked_stock = ValuationGenerator::Value.new("#{@stock_symbol_name}")

    # Public: This calls the compute_stock_price method on the Value object, picked_stock, and assigns the float value that the method generates to the variable @our_stock_price.  It only does this if @picked_stock can be used in a valuation.
    val = @picked_stock.compute_share_value
    val ? @our_stock_price = '%.2f' % val : (return false)
    
  end

  # Public: The page where the user's final valuation is displayed.
  def results

    # Public: This calls the module containing the ModValue class.
    require "#{Rails.root}/lib/modules/valuation_generator.rb"

    # Public: Assigns the user inputed stock's proper name as a string to the variable @mod_stock_name.
  	@mod_stock_name = params[:mod_stock_fullName]

    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @mod_stock_symbol.
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]

    # Public: This create a new ModValue object, mod_stock, using the stock symbol string that the user selected.  
    mod_stock = ValuationGenerator::ModValue.new("#{@mod_stock_symbol}")

    risk_free_mod = (params[:mod_stock_riskFreeRate]).to_f
    market_growth_mod = (params[:mod_stock_marketGrowthRate]).to_f

    # Public: This calls the compute_stock_price method on the ModValue object, mod_stock, that we had created.  It then assigns the float value that the method generates to the variable @mod_stock_value.
  	@mod_stock_value = '%.2f' % mod_stock.compute_share_value(risk_free_mod, market_growth_mod)
  end
end

