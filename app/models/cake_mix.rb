class CakeMix < ActiveRecord::Base
  attr_accessible :StockSymbol

  # First, take the user's stock symbol and generate their database values using the stock model
  # Second, bring those values to the picker controller
  # Third, use those values to populate the picker and help the user make decisions
  # Fourth, enter the user created values from the picker in the cake mix module in the controller 
  # Fifth, run the cake mix stock valuation module to produce their value.
  # Sixth, spit out that value to the results page

  # Rails destroy model cake_mix
  # New takes data from the Stock model
  # Show takes data from new's routes and uses thew cake mix model to create a value
  # Then show outputs the value



end
