require 'rest_client'

module GeoHelper
	def timeshift
		zone = RestClient.get "http://api.geonames.org/timezone?lat=#{latitude}&lng=#{longitude}&username=instatrace"
		# zone = RestClient.get "http://api.geonames.org/timezone?lat=#{latitude}&lng=#{longitude}&username=textbuster"
		Hash.from_xml(zone)["geonames"]["timezone"]["gmtOffset"].to_f rescue nil
	end
end