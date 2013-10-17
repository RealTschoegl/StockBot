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

    # Public: Calls the serve_stock method so it can determine if the stock exists in the database and can be used in a valuation. 
    @picked_stock = serve_stock(@stock_symbol_name, @stock_proper_name)

    # Public: This calls the compute_stock_price method on the Value object, picked_stock, and assigns the float value that the method generates to the variable @our_stock_price.  It only does this if @picked_stock can be used in a valuation.
    @our_stock_price = @picked_stock.compute_stock_price if @picked_stock
    
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

  private 

  # Private: This method determines whether a given stock is in the database already and is complete.  If it is, it gets the valuation for that stock and assigns it to @picked_stock.  If it is in the database, but not complete, then it returns false.  If it is not in the database, it calls a method that will add the stock to the database from the API.  It then calls the method recursively so it can then return true or false depending on whether the API has intact information.
  #
  # stock_symbol_name - String, the stock symbol of the stock that you want the data for
  # stock_proper_name - String, the official name of the stock that you want the data for
  #
  # Examples
  #
  #   serve_stock("YHOO", "Yahoo, Inc.")
  #   # => true
  helper_method :serve_stock
  def serve_stock(stock_symbol_name, stock_proper_name )
    if check_database_for_stock(stock_symbol_name) && is_stock_complete(stock_symbol_name)
      @picked_stock = ValuationEngine::Value.new(@stock_symbol_name)
    elsif check_database_for_stock(stock_symbol_name) && !is_stock_complete(stock_symbol_name)
      return false
    elsif !check_database_for_stock(stock_symbol_name) 
      @new_stock = Stock.find_stock(stock_symbol_name, stock_proper_name)
      serve_stock(stock_symbol_name, stock_proper_name)
    else 
      return false 
    end
  end


  # Private: This method determines whether a given stock is in the database already.
  #
  # stock_symbol_name - String, the stock symbol of the stock that you want the data for
  #
  # Examples
  #
  #   check_database_for_stock("YHOO")
  #   # => true
  def check_database_for_stock(stock_symbol_name)
    if !Stock.where(:stock_ticker => stock_symbol_name).empty? 
      return true
    else
      return false
    end
  end

  # Private: This method determines whether a given stock has the data that our stock valuation requires.
  #
  # stock_symbol_name - String, the stock symbol of the stock that you want the data for
  #
  # Examples
  #
  #   is_stock_complete("YHOO")
  #   # => true
  def is_stock_complete(stock_symbol_name)
    properties = Stock.where(:stock_ticker => stock_symbol_name)
    if properties[0].beta.nil? || properties[0].PE_ratio.nil? || properties[0].free_cash_flow.nil? || properties[0].num_shares.nil?
      properties[0].complete = false
      properties[0].save

      return false
    else
      properties[0].complete = true
      properties[0].save

      return true
    end
  end

end

