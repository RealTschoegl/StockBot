---
layout: default
title: Database Migrations
category: "Ratios"
published: true
---

def change 
	rename_column :stock, :PE_ratio, :current_pe_ratio
	rename_column :company, :PE_Comparable_Valuation, :current_pe_comp
	
end