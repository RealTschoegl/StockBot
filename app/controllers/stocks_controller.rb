class StocksController < ApplicationController

  def index
    
  end

  def picker
    require "#{Rails.root}/lib/modules/valuation_engine.rb"
    
  	@stock_proper_name = params[:stock_symbol]
    @stock_symbol_name = params[:stock_tbd]
    picked_stock = ValuationEngine::Value.new(params[:stock_tbd])
    @our_stock_price = picked_stock.compute_stock_price
  end

  def results
    require "#{Rails.root}/lib/modules/valuation_engine.rb"

  	@mod_stock_name = params[:mod_stock_fullName]
  	@mod_stock_symbol = params[:mod_stock_fullSymbol]
    mod_stock = ValuationEngine::ModValue.new(params[:mod_stock_fullSymbol])

    # Public: An integer value that represents the number of years from now that we would intend to sell the stock.  Here we use the number of years that the user would like to hold onto the stock.
    mod_stock.class.years_horizon = (params[:mod_stock_yearHorizon]).to_i

    # Public: A float value to four digits that represents the lowest possible borrowing value. Here we use the 5 year treasury yield at market as the base value and adjust it based on how they think the US gov't will manage the money supply.
    mod_stock.class.risk_free_rate = (0.0141 * (params[:mod_stock_riskFreeRate]).to_f).round(4)

    # Public: A float value to four digits that represents the amount that the market grew in the previous year. Here we use the S&P500 1 year growth rate as the base rate and adjust it with the user's estimate of how the market will do over the period that they intend to hold the stock for.
    mod_stock.class.market_growth_rate = (0.2038 + (params[:mod_stock_marketGrowthRate]).to_f/100).round(4)

    @stuffington = mod_stock

  	@mod_stock_value = mod_stock.compute_stock_price
  end

end

