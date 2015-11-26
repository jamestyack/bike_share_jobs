#!/bin/bash

. ~jamestyack/.bash_profile
echo "Getting Indego stations (Philly)"
ruby ruby/load_bike_stations.rb indego
