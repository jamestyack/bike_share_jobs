#!/bin/bash

. ~jamestyack/.bash_profile
echo "Getting Indego bikes (Philly)"
ruby ruby/station_snap_job.rb config/config.yaml indego
echo "Getting Babs bikes (Bay Area)"
ruby ruby/station_snap_job.rb config/config.yaml babs
