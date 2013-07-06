class StocksController < Application Controller
	def index

	end

	def show
		@Stock = Stock.composite_valuation
		@Stock_price = Stock.get_stock_value
	end



end
