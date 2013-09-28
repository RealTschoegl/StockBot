namespace :completer do

	desc "Fills out the holes in the data using a scraper"
	task :check => :environment do
		Stock.incomplete.find_each do |fragment|
			problemStock = fragment.stock_ticker.downcase
			API_response = HTTParty.get("http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.keystats%20WHERE%20symbol%20%3D%20%20'#{problemStock}'&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")

			apiFCF = API_response["query"]["results"]["stats"]["OperatingCashFlow"]["content"]
			apiNumShares = API_response["query"]["results"]["stats"]["SharesOutstanding"]
			apiBeta = API_response["query"]["results"]["stats"]["Beta"]
			apiPE = API_response["query"]["results"]["stats"]["ForwardPE"]["content"]

			if fragment.free_cash_flow.nil? && apiFCF != "N/A"
				fragment.free_cash_flow = (apiFCF.to_i / 1000000) 
			end

			if fragment.num_shares.nil? && apiNumShares != "N/A"
				fragment.num_shares = (apiNumShares.to_i / 1000000) 
			end

			if fragment.beta.nil? && apiBeta != "N/A"
				fragment.beta = apiBeta.to_f 
			end

			if fragment.PE_ratio.nil? && apiPE != "N/A"
		  	fragment.PE_ratio = apiPE.to_f  
		  end

			fragment.save
		end

	end

end