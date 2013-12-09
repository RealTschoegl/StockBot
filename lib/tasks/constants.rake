namespace :constants do

	desc "Update the financial constants with an API call"
	task :find => :environment do
		date_today = Time.now.strftime("%F")
		date_yesterday = Chronic.parse("yesterday").strftime("%F")
		year_ago_today = Chronic.parse("one year ago").strftime("%F")

		treasury10year = HTTParty.get("http://www.quandl.com/api/v1/datasets/FRED/DGS10.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&sort_order=desc")
		$financialConstant.set("riskFreeRate", (treasury10year["data"][0][1] / 100))

		NASDAQrate = HTTParty.get("http://www.quandl.com/api/v1/datasets/YAHOO/INDEX_IXIC.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&transformation=rdiff&sort_order=desc")
		$financialConstant.set("marketGrowthRateNSDQ", NASDAQrate["data"][0][6])

		NYSERate = HTTParty.get("http://www.quandl.com/api/v1/datasets/YAHOO/INDEX_NYA.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&transformation=rdiff&sort_order=desc")
		$financialConstant.set("marketGrowthRateNYSE", NYSERate["data"][0][6])

		discountRate = HTTParty.get("http://www.quandl.com/api/v1/datasets/OFDP/INDEX_WSJ_MONEYRATES_137.json?&trim_start=#{date_yesterday}&trim_end=#{date_yesterday}&sort_order=desc")
		$financialConstant.set("overnightDiscountRate", discountRate["data"][0][1])

		HYBondRate = HTTParty.get("http://www.quandl.com/api/v1/datasets/OFDP/INDEX_WSJ_BENCHMARK_32.json?&trim_start=#{date_yesterday}&trim_end=#{date_yesterday}&sort_order=desc")
		$financialConstant.set("highYieldBond", HYBondRate["data"][0][2])

		IGBondRate = HTTParty.get("http://www.quandl.com/api/v1/datasets/OFDP/INDEX_WSJ_BENCHMARK_29.json?&trim_start=#{date_yesterday}&trim_end=#{date_yesterday}&sort_order=desc")
		$financialConstant.set("investmentGradeBond", IGBondRate["data"][0][2])

	end

end