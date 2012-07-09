require 'rest_client'

module GeoHelper
	def timeshift
		zone = RestClient.get "http://api.geonames.org/timezone?lat=#{latitude}&lng=#{longitude}&username=instatrace"
		Hash.from_xml(zone)["geonames"]["timezone"]["gmtOffset"].to_f
	end
end