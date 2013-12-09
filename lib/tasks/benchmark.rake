namespace :benchmark do

	desc "Get the benchmarks for the valuation generator"
	task :report => :environment do
		require "#{Rails.root}/lib/modules/valuation_generator.rb"

		Benchmark.bmbm do |bm|
			bm.report {
				process = ValuationGenerator::Value.new("MSFT")
				process.compute_share_value
			}
		end
	end

end