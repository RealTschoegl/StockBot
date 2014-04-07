---
layout: default
title: Dummy Demo
category: "Ratios"
published: true
---

Variables:
stocks database: xxxx_ratio
company database: xxxx_comp
kosher: xxx_xxx_kosher?
valuation equation: get_xxxx_ratio_comparable
data point equation: get_xxxx_ratio
company view: @xxxx_comp_view
Quandl Variable: "XXXXX"
API Variable: "XXXXXXX Value"


1. Add conditional statement in get_data method to add the new value to the computed_share_value array:

xxx_xxx_kosher? ? @composite_share_values << (@xxxx_comp = get_xxxx_ratio_comparable) : @composite_share_values << (@xxxx_comp = nil)

2. Create valuation equation:

def get_xxxx_ratio_comparable
	comparables = @sorted_comparables
	new_array = [] 
	comparables.each {|item| new_array << item.xxxx_ratio;}
	@xxxx_comp = @current_stock_price * ( ((new_array.inject(:+) / new_array.count).to_f) / @xxxx_ratio)

  return @xxxx_comp
end

3. Create equation prerequisite method:

def xxx_xxx_kosher?
	get_xxxx_ratio && get_weighted_quote && get_market_cap && get_comparables:
end

4. Create the subordinate methods for the equation prerequisite that get/check relevant pieces of data:

def get_xxxx_ratio
	if @get_xxxx_ratio.nil?
		if !@quandlStockData.nil? && @quandlStockData.has_key?("XXXXX") && !@quandlStockData["XXXXX"].nil?
			@get_xxxx_ratio = @quandlStockData["XXXXX"].to_f
		elsif @databaseValues.respond_to?("get_xxxx_ratio") && !@databaseValues["get_xxxx_ratio"].nil?
			@get_xxxx_ratio = @databaseValues["get_xxxx_ratio"]
		else
			@get_xxxx_ratio = nil
		end
	else
		return true
	end
end

5. Determine where the data will come for the prerequisite methods
"Current PE Ratio"

6. Add the new computed value to the hashpack hash:

"xxxx_comp" => self.instance_variable_get(:@xxxx_comp)

7. Add the new data input to the hashpack:

"xxxx_ratio" => self.instance_variable_get(:@xxxx_ratio)

8. Add newly computed value to company model for both method:

new_company.xxxx_comp = computed["xxxx_comp"]
update_company.xxxx_comp = computed["xxxx_comp"]

9. Add new API data point to stock model for both methods:

new_stock.xxxx_ratio = computed["xxxx_ratio"]
updated_stock.xxxx_ratio = computed["xxxx_ratio"]

10. Migrate stock database to allow for the new value:
add_column :stocks, :xxxx_ratio, :float

11. Migrate companies database to allow for the new value
add_column :companies, :xxxx_comp, :float

12. Revise or Add ModValue equations: 

xxx_xxx_kosher? ? @composite_share_values << (@xxxx_comp = get_xxxx_ratio_comparable) : @composite_share_values << (@xxxx_comp = nil)

def xxx_xxx_kosher?
	get_xxxx_ratio && get_weighted_quote && get_market_cap && get_comparables
end


13. Add the new value to the company view
tr
 	td
 		|
 		b Current PE Comparable Valuation:
	td
		= @xxxx_comp_view

14. Add the new value to the company controller view

!@company.xxxx_comp.nil? ? @xxxx_comp_view = (@company.xxxx_comp).round(2) : @xxxx_comp_view = "N/A"

15. Change attribute accessor to reflect new database field
:xxxx_ratio

16. Add company to completeness method in Company Helper
data.xxxx_comp

17. Add valuation to api controller 
!reports.xxxx_comp.nil? ? @api_data_packet["XXXXXXX Value"] = (reports.xxxx_comp).round(2) : @api_data_packet["XXXXXXX Value"] = nil

18. Add valuation to api view
@api_values = ["XXXXXXX Value"]

