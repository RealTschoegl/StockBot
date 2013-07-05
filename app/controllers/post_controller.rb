class StockController < Application Controller
	def index

	end

	def show
		@Stock = Stock.composite_valuation
	end


end
