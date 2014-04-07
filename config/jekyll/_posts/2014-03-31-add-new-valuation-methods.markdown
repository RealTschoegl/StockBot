---
layout: default
title: Add New Valuation Methods
category: "Ratios"
published: true
---

1. Add conditional statement in get_data method to add the new value to the computed_share_value array
2. Create valuation equation 
3. Create equation prerequisite method
4. Create the subordinate methods for the equation prerequisite that get/check relevant pieces of data
5. Determine where the data will come for the prerequisite methods
6. Add the new computed value to the hashpack hash
7. Add the new data input to the hashpack
8. Add newly computed value to company model for both method
9. Add new API data point to stock model for both methods
10. Migrate stocks database to allow for the new value 
11. Migrate companies database to allow for the new value
12. Revise ModValue equations if any new equations have 
13. Add the new value to the company view
14. Add the new value to the company controller view