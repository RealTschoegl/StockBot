class Stock < ActiveRecord::Base
  attr_accessible :company, :stock_ticker, :current_stock_price, :free_cash_flow, :num_shares, :PE_ratio, :beta, :cost_of_equity, :fcf_share_value, :capm_share_value, :composite_share_value, :complete 

  def self.new_stock(computed)
    new_stock = Stock.new

    new_stock.earnings_growth = computed["company_growth"]
    new_stock.forw_div_rate = computed["forward_dividend"]
    new_stock.trail_div_rate = computed["trailing_dividend"]
    new_stock.eff_tax_rate = computed["tax_rate"]
    new_stock.company = computed["trade_name"]
    new_stock.stock_ticker = computed["stock_ticker"]
    new_stock.free_cash_flow = computed["free_cash_flow"]
    new_stock.num_shares = computed["number_shares"]
    new_stock.current_pe_ratio = computed["current_pe_ratio"]
    new_stock.beta = computed["beta"]
    new_stock.industry = computed["industry"]
    new_stock.sic_code = computed["sic_code"]
    new_stock.exchange = computed["exchange"]
    new_stock.mkt_cap = computed["market_cap"]
    new_stock.assets = computed["net_assets"]
    new_stock.debt = computed["total_debt"]

    new_stock.save
  end

  def self.update_stock(computed)
    updated_stock = Stock.where(stock_ticker: computed["stock_ticker"]).first

    updated_stock.mkt_cap = computed["market_cap"]
    updated_stock.assets = computed["net_assets"]
    updated_stock.debt = computed["total_debt"]
    updated_stock.free_cash_flow = computed["free_cash_flow"]
    updated_stock.num_shares = computed["number_shares"]
    updated_stock.current_pe_ratio = computed["current_pe_ratio"]
    updated_stock.beta = computed["beta"]
    updated_stock.earnings_growth = computed["company_growth"]
    updated_stock.forw_div_rate = computed["forward_dividend"]
    updated_stock.trail_div_rate = computed["trailing_dividend"]
    updated_stock.eff_tax_rate = computed["tax_rate"]

    updated_stock.save

  end

  # Public: A scope that gets all of the stocks that were updated before the time indicated in the parameter
  #
  # time - DateTime, the time before which we want all of the stocks
  #
  # Example
  #
  #       Stock.updated_before(time).first
  #
  # Returns the stock's active record relation
  scope :updated_before, ->(time) { where("updated_at < ?", time) }

  # Public: A scope that gets all of the stocks that are incomplete
  #
  # Example
  #
  #       Stock.incomplete.first
  #
  # Returns the stock's active record relation
  scope :incomplete, -> { where(complete: false) }

  scope :sector, ->(id, code) { where("id != ? AND sic_code = ?", id, code)}

end



	
