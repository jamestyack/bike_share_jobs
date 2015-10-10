require 'rest_client'
require 'mongo'
require 'dotenv'
require 'json'
require 'pp'
require "#{Dir.pwd}/lib/common_lib.rb"

Dotenv.load
if ARGV.empty? || ARGV.size != 2
  puts "Usage: station_snap_job.rb config/config.yaml {stationId e.g. indego / babs}"
  exit
end
system_id = ARGV[1]
config = YAML::load(File.open(ARGV[0]))
@snapshot_mapping = config['snapshot_field_maps'][system_id]
@station_status_mapping = config['station_status_maps'][system_id]

@client = Mongo::Client.new(ENV['MONGO_URL'])
@bike_systems_coll = @client['bike_systems']
@station_snaps_coll = @client["station_snaps_#{system_id}"]
@station_snap_summary_coll = @client["station_snaps_summary_#{system_id}"]
@api_url = @bike_systems_coll.find({:_id => system_id}).first["api_url"]

def convert_and_store(system_id, station, ts)
  snap_to_store = {}
  snap_to_store["_id"] = {}
  snap_to_store["_id"]["stationId"] = get_from_hash(@snapshot_mapping["id"], station)
  snap_to_store["_id"]["systemId"] = system_id
  snap_to_store["_id"]["ts"] = ts
  snap_to_store["id"] = get_from_hash(@snapshot_mapping["id"], station)
  @snapshot_mapping["others"].each_pair { |name, val|
    snap_to_store[name] = get_from_hash(val, station)
  }
  #@station_snaps_coll.insert_one(snap_to_store)
  snap_to_store.delete("_id")
  snap_to_store
end

stations_from_api = JSON.parse(RestClient.get @api_url)
stations_list = stations_from_api[@snapshot_mapping["container"]]
ts = Time.now
converted_stations = stations_list.map { | station | convert_and_store(system_id, station, ts) }

# now get summaries for all - and persist single doc with all stations and summary?

bikes_ava_tot = converted_stations.inject(0) { | sum, station | sum + station["bikeAva"].to_i }
dock_ava_tot = converted_stations.inject(0) { | sum, station | sum + station["dockAva"].to_i }
dock_tot = converted_stations.inject(0) { | sum, station | sum + station["dockTot"].to_i }

snaps_to_store = {}
snaps_to_store["_id"] = {}
snaps_to_store["_id"]["systemId"] = system_id
snaps_to_store["_id"]["ts"] = ts
snaps_to_store["totBikesAva"] = bikes_ava_tot
snaps_to_store["totDocksAva"] = dock_ava_tot
snaps_to_store["totDocks"] = dock_tot
snaps_to_store["stations"] = converted_stations

@station_snap_summary_coll.insert_one(snaps_to_store)

pp "*** tot bikes_ava #{bikes_ava_tot}"
pp "*** tot docks_ava #{dock_ava_tot}"
pp "*** tot docks #{dock_tot}"
