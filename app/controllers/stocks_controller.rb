class StocksController < ApplicationController

  # Public: The front page of the site where the user inputs the stock. 
  def index
    
  end

  # Public: The page where the user makes their customized choices to be inputed into the final valuation.
  def picker

    # Public: This calls the module containing the Value class.
    require "#{Rails.root}/lib/modules/valuation_engine.rb"
    
    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @stock_proper_name
  	@stock_proper_name = params[:stock_symbol]

    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @stock_symbol_name
    @stock_symbol_name = params[:stock_tbd]

    # Public: This create a new Value object, picked_stock, using the stock symbol string that the user selected. 
    if !Stock.where(:stock_ticker => @stock_symbol_name).empty? 
      @picked_stock = ValuationEngine::Value.new(params[:stock_tbd])
    else 
      return false
    end

    # Public: This calls the compute_stock_price method on the Value object, picked_stock, and assigns the float value that the method generates to the variable @our_stock_price.
    @our_stock_price = @picked_stock.compute_stock_price
  end

  # Public: The page where the user's final valuation is displayed.
  def results

    # Public: This calls the module containing the ModValue class.
    require "#{Rails.root}/lib/modules/valuation_engine.rb"

    # Public: Assigns the user inputed stock's proper name as a string to the variable @mod_stock_name.
  	@mod_stock_name = params[:mod_stock_fullName]

    # Public: Assigns the user inputed stock's stock symbol as a string to the variable @mod_stock_symbol.
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]

    # Public: This create a new ModValue object, mod_stock, using the stock symbol string that the user selected.  
    mod_stock = ValuationEngine::ModValue.new(params[:mod_stock_fullSymbol])

    # Public: An integer value that represents the number of years from now that we would intend to sell the stock.  Here we use the number of years that the user would like to hold onto the stock.
    mod_stock.class.years_horizon = (params[:mod_stock_yearHorizon]).to_i

    # Public: A float value to four digits that represents the lowest possible borrowing value. Here we use the 5 year treasury yield at market as the base value and adjust it based on how they think the US gov't will manage the money supply.
    mod_stock.class.risk_free_rate = (0.0141 * (params[:mod_stock_riskFreeRate]).to_f).round(4)

    # Public: A float value to four digits that represents the amount that the market grew in the previous year. Here we use the S&P500 1 year growth rate as the base rate and adjust it with the user's estimate of how the market will do over the period that they intend to hold the stock for.
    mod_stock.class.market_growth_rate = (0.2038 + (params[:mod_stock_marketGrowthRate]).to_f/100).round(4)

    # Public: This calls the compute_stock_price method on the ModValue object, mod_stock, that we had created.  It then assigns the float value that the method generates to the variable @mod_stock_value.
  	@mod_stock_value = mod_stock.compute_stock_price
  end

end

