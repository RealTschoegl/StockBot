uri = URI.parse(ENV["REDISTOGO_URL"])
$financialConstant = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)