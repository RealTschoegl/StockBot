module API
	class ValuationsController < ApplicationController

		def index
			@api_values = ["Composite Share Value","Current PE Ratio Comparable Value","Net Asset Value Share Value","CAPM Share Value","WACC Share Value","Dividend Share Value","Sentiment Share Value"]
			render layout: "companies_index"
		end

		def show
			failureMessage = { :error => "Sorry, StockBot either does not have a valuation for that stock or does not recognize the stock ticker symbol.  Please check that you entered it correctly."}

			@valuationRequest = params[:valuation]
			stockRequest = params[:id]

			@api_data_packet = { "Stock Symbol" => stockRequest}
			
			reports = Company.where(slug: stockRequest).first

    	!reports.composite_share_value.nil? ? @api_data_packet["Composite Share Value"] = (reports.composite_share_value).round(2) : @api_data_packet["Composite Share Value"] = nil
    	!reports.current_pe_comp.nil? ? @api_data_packet["Current PE Ratio Comparable Value"] = (reports.current_pe_comp).round(2) : @api_data_packet["Current PE Ratio Comparable Value"] = "N/A"
    	!reports.NAV_Valuation.nil? ? @api_data_packet["Net Asset Value Share Value"] = (reports.NAV_Valuation).round(2) : @api_data_packet["Net Asset Value Share Value"] = "N/A"
    	!reports.CAPM_Valuation.nil? ? @api_data_packet["CAPM Share Value"] = (reports.CAPM_Valuation).round(2) : @api_data_packet["CAPM Share Value"] = "N/A"
    	!reports.WACC_Valuation.nil? ? @api_data_packet["WACC Share Value"] = (reports.WACC_Valuation).round(2) : @api_data_packet["WACC Share Value"] = "N/A"
    	!reports.Dividend_Valuation.nil? ? @api_data_packet["Dividend Share Value"] = (reports.Dividend_Valuation).round(2) : @api_data_packet["Dividend Share Value"] = "N/A"
    	!reports.Sentiment_Valuation.nil? ? @api_data_packet["Sentiment Share Value"] = (reports.Sentiment_Valuation).round(2) : @api_data_packet["Sentiment Share Value"] = "N/A"

			if !reports.nil? && !@valuationRequest.nil?
				valuation_quote = params[:valuation].gsub /"/, ''
				@measure = { "Stock Symbol" => stockRequest, valuation_quote => @api_data_packet[valuation_quote]}
				render json: @measure, status: :ok
			elsif !reports.nil?
				render json: @api_data_packet, status: :ok
			else
				render json: failureMessage, status: :not_found
			end
		end
	end
end