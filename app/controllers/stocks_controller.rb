class StocksController < ApplicationController

	def index

	end

	def show
		# @Stock = Stock.composite_valuation
		# @Stock_price = Stock.get_stock_value
	end

  def get_stock_ticker
     @stock_ticker_symbol = params[:data]
  end

end
