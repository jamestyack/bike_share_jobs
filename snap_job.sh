#!/bin/bash
echo "Getting Indego bikes (Philly)"
. ~jamestyack/.bash_profile

ruby ruby/station_snap_job.rb config/config.yaml indego
