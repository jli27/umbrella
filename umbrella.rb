# Write your solution here!
require "http"
require "json"
require "dotenv/load"

puts "Where are you?"
location = gets.chomp.capitalize
puts "Checking the weather at #{location}...."

gmaps_key = ENV.fetch("GOOGLE_MAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{gmaps_key}"

gmaps_data = HTTP.get(gmaps_url)
gmaps_data_parsed = JSON.parse(gmaps_data)

loc_results = gmaps_data_parsed.fetch("results")
loc_hash = loc_results.at(0)
loc_geo = loc_hash.fetch("geometry")
loc_loc = loc_geo.fetch("location")

lat = loc_loc.fetch("lat")
lng = loc_loc.fetch("lng")

puts "Your coordinates are #{lat}, #{lng}."

pirate_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_url = "https://api.pirateweather.net/forecast/#{pirate_key}/#{lat},#{lng}"

pirate_data = HTTP.get(pirate_url)
pirate_data_parsed = JSON.parse(pirate_data)

temp = (pirate_data_parsed.fetch("currently")).fetch("temperature")

puts "It is currently #{temp}°F."

next_hour = pirate_data_parsed.fetch("minutely", false)

if next_hour
  puts "Next Hour: #{next_hour.fetch("summary")}"
end
