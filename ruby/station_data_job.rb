require 'rest_client'
require 'mongo'
require 'dotenv'
require 'json'
require 'pp'

Dotenv.load
system_id = "babs"

@client = Mongo::Client.new(ENV['MONGO_URL'])
@bike_systems_coll = @client['bike_systems']
@api_url = @bike_systems_coll.find({:_id => system_id}).first["api_url"]

stations_from_api = JSON.parse(RestClient.get @api_url)

execution_time = stations_from_api["executionTime"]
stations_list = stations_from_api["stationBeanList"]

pp stations_list[0]

# get current date (in appropriate timezone based on system... e.g. Bay Area is PST)
