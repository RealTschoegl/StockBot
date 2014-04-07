---
layout: default
title: Current PE
category: "Ratios"
published: true
---

1. Add conditional statement in get_data method to add the new value to the computed_share_value array:

current_pe_kosher? ? @composite_share_values << (@current_pe_comp = get_current_pe_ratio_comparable) : @composite_share_values << (@current_pe_comp = nil)

2. Create valuation equation:

def get_current_pe_ratio_comparable
	comparables = @sorted_comparables
	new_array = [] 
	comparables.each {|item| new_array << item.current_PE_ratio;}
	@current_pe_comp = @current_stock_price * ( ((new_array.inject(:+) / new_array.count).to_f) / @current_pe_ratio)

  return @current_pe_comp
end

3. Create equation prerequisite method:

def current_pe_kosher?
	get_current_PE_ratio && get_weighted_quote && get_market_cap && get_comparables:
end

4. Create the subordinate methods for the equation prerequisite that get/check relevant pieces of data:

def get_current_PE_ratio
	if @current_pe_ratio.nil?
		if !@quandlStockData.nil? && @quandlStockData.has_key?("Current PE Ratio") && !@quandlStockData["Current PE Ratio"].nil?
			@current_pe_ratio = @quandlStockData["Current PE Ratio"].to_f
		elsif @databaseValues.respond_to?("current_pe_ratio") && !@databaseValues["current_pe_ratio"].nil?
			@current_pe_ratio = @databaseValues["current_pe_ratio"]
		else
			@current_pe_ratio = nil
		end
	else
		return true
	end
end

5. Determine where the data will come for the prerequisite methods
"Current PE Ratio"

6. Add the new computed value to the hashpack hash:

"current_pe_comp" => self.instance_variable_get(:@current_pe_comp),

7. Add the new data input to the hashpack:

"current_pe_ratio" => self.instance_variable_get(:@current_pe_ratio),

8. Add newly computed value to company model for both method:

new_company.PE_Comparable_Valuation = computed["current_pe_comp"]
update_company.PE_Comparable_Valuation = computed["current_pe_comp"]

9. Add new API data point to stock model for both methods:

new_stock.PE_ratio = computed["current_pe_ratio"]
updated_stock.PE_ratio = computed["current_pe_ratio"]

10. Migrate stock database to allow for the new value:
rename_column :stock, :PE_ratio, :current_pe_ratio

11. Migrate companies database to allow for the new value
rename_column :company, :PE_Comparable_Valuation, :current_pe_comp

12. Revise or Add ModValue equations: 

current_pe_kosher? ? @composite_share_values << (@current_pe_comp = get_current_pe_ratio_comparable) : @composite_share_values << (@current_pe_comp = nil)

def current_pe_kosher?
	get_current_PE_ratio && get_weighted_quote && get_market_cap && get_comparables
end 


13. Add the new value to the company view
tr
 	td
 		|
 		b Current PE Comparable:
	td
		= @current_pe_value 

14. Add the new value to the company controller view

!@company.current_pe_comp.nil? ? @current_pe_value = (@company.current_pe_comp).round(2) : @pe_value = "N/A"


15. Change attribute accessor to reflect new database field
:current_pe_ratio
