class CompaniesController < ApplicationController

  def index
    @firms = Company.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order('company_name ASC')
    render layout: "companies_index"
  end

  def show
    @company = Company.find(params[:id])

    render layout: "companies_show"
  end

  def search
    @firms = Company.search(params[:search])
  end

end
