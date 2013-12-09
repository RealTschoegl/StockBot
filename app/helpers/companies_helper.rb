module CompaniesHelper


	# Public: This method determines how much of the data necessary for a valuation exists for a Company entry.
	#
	# Returns a float value.
	def companyComplete(data)
		array = [data.PE_Comparable_Valuation, data.NAV_Valuation, data.CAPM_Valuation, data.WACC_Valuation, data.Dividend_Valuation, data.Sentiment_Valuation]

		percentage = (array.compact.count.to_f / array.count.to_f)


		return "#{'%.2f' % (percentage*100)}%"
	end
end
