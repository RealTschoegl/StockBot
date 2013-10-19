class CompaniesController < ApplicationController

  def index
    @firms = Company.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order('company_name ASC')
    render layout: "companies_index"
  end

  def show
    require "#{Rails.root}/lib/modules/valuation_engine.rb"
    @yearsConstant = ValuationEngine::Value.years_horizon
    @riskFreeConstant = (ValuationEngine::Value.risk_free_rate * 100).round(2)
    @marketGrowthConstant = (ValuationEngine::Value.market_growth_rate * 100).round(2)
    @company = Company.find(params[:id])

    render layout: "companies_show"
  end

  def search
    @firms = Company.search(params[:search])
  end

end
