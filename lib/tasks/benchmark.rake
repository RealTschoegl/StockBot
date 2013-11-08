namespace :benchmark do

	desc "Get the benchmarks for the valuation generator"
	task :find => :environment do
		require "#{Rails.root}/lib/modules/valuation_generator.rb"

		puts Benchmark.measure { ValuationGenerator::Value.compute_share_value("MSFT") }
	end

end