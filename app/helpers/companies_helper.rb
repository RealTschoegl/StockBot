module CompaniesHelper


	# Public: This method determines how much of the data necessary for a valuation exists for a Company entry.
	#
	# Returns a float value.
	def companyComplete(data)
		counter1 = 0
		counter2 = 0
		points = [data.free_cash_flow, data.num_shares, data.PE_ratio, data.beta]

		points.each do |check|
			counter1 += 1 if !check.nil?
			counter2 += 1
		end

		return "#{(counter1 * 100)/counter2}%"
	end
end
