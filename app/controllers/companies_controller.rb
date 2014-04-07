class CompaniesController < ApplicationController

  def index
    @firms = Company.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order('company_name ASC')
    render layout: "companies_index"
  end

  def show
    @company = Company.find(params[:id])
    !@company.current_stock_price.nil? ? @stock_price = (@company.current_stock_price).round(2) : @stock_price = "N/A"
    !@company.composite_share_value.nil? ? @share_value = (@company.composite_share_value).round(2) : @share_value = "N/A"
    !@company.current_pe_comp.nil? ? @current_pe_value = (@company.current_pe_comp).round(2) : @current_pe_value = "N/A"
    !@company.NAV_Valuation.nil? ? @nav_value = (@company.NAV_Valuation).round(2) : @nav_value = "N/A"
    !@company.CAPM_Valuation.nil? ? @capm_value = (@company.CAPM_Valuation).round(2) : @capm_value = "N/A"
    !@company.WACC_Valuation.nil? ? @wacc_value = (@company.WACC_Valuation).round(2) : @wacc_value = "N/A"
    !@company.Dividend_Valuation.nil? ? @dividend_value = (@company.Dividend_Valuation).round(2) : @dividend_value = "N/A"
    !@company.Sentiment_Valuation.nil? ? @sentiment_value  = (@company.Sentiment_Valuation).round(2) : @sentiment_value = "N/A"

    render layout: "companies_show"
  end

  def search
    @firms = Company.search(params[:search])
  end

end
