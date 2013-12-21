require 'tradier'

$tradier_client = Tradier::Client.new(:access_token => ENV['TRADIER_TOKEN'])
