namespace :constants do

	desc "Update the financial constants with an API call"
	task :find => :environment do
		date_today = Time.now.strftime("%F")
		year_ago_today = Time.now.change(:year => Time.now.year - 1).strftime("%F")

		treasury10year = HTTParty.get("http://www.quandl.com/api/v1/datasets/FRED/DGS10.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&sort_order=desc")
		$financialConstant.set("riskFreeRate", (treasury10year["data"][0][1] / 100))

		NASDAQrate = HTTParty.get("http://www.quandl.com/api/v1/datasets/YAHOO/INDEX_IXIC.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&transformation=rdiff&sort_order=desc")
		$financialConstant.set("marketGrowthRateNSDQ", NASDAQrate["data"][0][6])

		NYSERate = HTTParty.get("http://www.quandl.com/api/v1/datasets/YAHOO/INDEX_NYA.json?&auth_token=#{ENV['QUANDL_API_TOKEN']}&trim_start=#{year_ago_today}&trim_end=#{date_today}&collapse=annual&transformation=rdiff&sort_order=desc")
		$financialConstant.set("marketGrowthRateNYSE", NYSERate["data"][0][6])

	end

end