require "#{Rails.root}/lib/modules/valuation_engine.rb"

FactoryGirl.define do
  factory :value, class: ValuationEngine::Value do 
    initialize_with { new("YHOO") }
  end

  factory :mod_value, class: ValuationEngine::ModValue do 
    initialize_with { new("YHOO") }
  end
end