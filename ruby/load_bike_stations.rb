# load bike station from appropriate REST api

# pass the 'system_id' to the script as an argument. e.g. indego or babs

require 'mongo'
require 'rest_client'
require 'dotenv'
require 'pp'
require 'yaml'

class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

# supports get from hash using dot notation e.g. "geometry.lat.1" (1 is array index)
# see http://stackoverflow.com/questions/6672007/how-do-you-access-nested-elements-of-a-hash-with-a-single-string-key
def get_from_hash(key, hash)
    key.to_s.split('.').inject(hash) { |h, k|
      h[k.is_i? ? k.to_i : k]
    }
end

Dotenv.load
if ARGV.empty? || ARGV.size != 1
  puts "Usages: Must pass system_id (e.g. indego, babs) as single argument"
  exit
end
system_id = ARGV[0]
config = YAML::load(File.open('../config/config.yaml'))
@station_mapping = config['station_field_maps'][system_id]

@client = Mongo::Client.new(ENV['MONGO_URL'])
@stations_coll = @client['stations']
@bike_systems_coll = @client['bike_systems']
@api_url = @bike_systems_coll.find({:_id => system_id}).first["api_url"]
#remove existing stations for this system_id
@stations_coll.find({"_id.systemId" => system_id}).delete_many

def convert_and_store(system_id, station)
  station_to_store = {}
  station_to_store["_id"] = {}
  station_to_store["_id"]["stationId"] = get_from_hash(@station_mapping["id"], station)
  station_to_store["loc"] = {}
  station_to_store["loc"]["type"] = "Point"
  station_to_store["loc"]["coordinates"] = []
  station_to_store["loc"]["coordinates"][0] = get_from_hash(@station_mapping["lon"], station)
  station_to_store["loc"]["coordinates"][1] = get_from_hash(@station_mapping["lat"], station)
  station_to_store["_id"]["systemId"] = system_id
  @station_mapping["others"].each_pair { |name, val|
    puts "finding #{val}"
    puts "#{get_from_hash(val, station)}"
    station_to_store[name] = get_from_hash(val, station)
  }
  @stations_coll.insert_one(station_to_store)
end

stations_from_api = JSON.parse(RestClient.get @api_url)
pp stations_from_api
stations_list = stations_from_api[@station_mapping["container"]]
stations_list.each { | station | convert_and_store(system_id, station) }
