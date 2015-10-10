# load the seed data from csv files

require 'mongo'
require 'rest_client'
require 'csv'
require 'dotenv'

Dotenv.load

@client = Mongo::Client.new(ENV['MONGO_URL'])
@bike_systems_coll = @client['bike_systems']
@bike_systems_coll.find().delete_many

systems = CSV.read("bike_share_metadata/bike_systems.csv")

result = []
keys = systems[0]

systems.drop(1).each do | line |
  iter=0
  assoc={}
  line.each do |v|
    assoc[keys[iter]] = v
    iter += 1
  end
  result.push assoc
end

puts "inserting bike_systems"
@bike_systems_coll.insert_many(result)
