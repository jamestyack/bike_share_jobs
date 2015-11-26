#!/bin/bash

. ~jamestyack/.bash_profile
echo "Getting Babs bikes (Bay Area)"
ruby ruby/load_bike_stations.rb babs
