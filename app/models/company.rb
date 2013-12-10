class Company < ActiveRecord::Base
  attr_accessible :stock_ticker

  include FriendlyId
  friendly_id :stock_ticker, :use => [:slugged]

	def self.search(search)
    if search
      where('stock_ticker LIKE ? OR company_name LIKE ?', "%#{search}%", "%#{search}%").order('company_name ASC')
    else
      order('company_name ASC')
    end
  end


  def self.build_company(computed)
    if Company.where(:stock_ticker => computed["stock_ticker"]).empty?
      new_company = Company.new

      new_company.stock_ticker = computed["stock_ticker"]
      new_company.company_name = computed["trade_name"]
      new_company.current_stock_price = computed["stock_price"]
      new_company.composite_share_value = computed["stockbot_price"]
      new_company.industry = computed["industry"]
      new_company.sic_code = computed["sic_code"]
      new_company.exchange = computed["exchange"]
      new_company.PE_Comparable_Valuation = computed["pe_value"]
      new_company.NAV_Valuation = computed["nav_value"]
      new_company.CAPM_Valuation = computed["capm_value"]
      new_company.WACC_Valuation = computed["wacc_value"]
      new_company.Dividend_Valuation = computed["dividend_value"]
      new_company.Sentiment_Valuation = computed["sentiment_value"]

      new_company.save
    else
      update_company = Company.where(:stock_ticker => computed["stock_ticker"]).first

      update_company.stock_ticker = computed["stock_ticker"]
      update_company.current_stock_price = computed["stock_price"]
      update_company.composite_share_value = computed["stockbot_price"]
      update_company.PE_Comparable_Valuation = computed["pe_value"]
      update_company.NAV_Valuation = computed["nav_value"]
      update_company.CAPM_Valuation = computed["capm_value"]
      update_company.WACC_Valuation = computed["wacc_value"]
      update_company.Dividend_Valuation = computed["dividend_value"]
      update_company.Sentiment_Valuation = computed["sentiment_value"]

      update_company.save
    end
  end

end
