#!/bin/bash

SLEEPT=1
RESULT_DIR="/home/kums/results/"
BASE_RESULT_FILE="$RESULT_DIR/sc_tuning"
CONFIG_JSON=$BASE_RESULT_FILE"_`date +%F-%T`.json"

get_user_input () {
        
        echo "Proceed to next step: Y/N"
        read user_input

}

echo "Tuning the Storage cluster: `date`"

echo "Login as Realm Admin and Verify Cluster"
#redcli user login realm_admin 
#redcli user list -t red
get_user_input

echo "Grant realm_admin access to red"
redcli user grant realm_admin red
redcli user grant realm_admin red/red
sleep $SLEEPT
get_user_input

echo "Disable compression"
redcli config show runtime  -o json | egrep 'compression'
sleep $SLEEPT
redcli config update auto_config --debug compression=off
redcli config select auto_config
sleep $SLEEPT
redcli config show runtime  -o json | egrep 'compression'
get_user_input

echo "Disable GC"
redcli config update auto_config --debug gc_horizon_time=9999
sleep $SLEEPT
redcli config update auto_config --debug reclaim_gc_enabled=false
sleep $SLEEPT
redcli config update auto_config --debug reclaim_gc_interval_sec=9999
sleep $SLEEPT
redcli config update auto_config --debug max_gc_renders_inflight=1
sleep $SLEEPT
redcli config update auto_config --debug intentlog_unmap=false
sleep $SLEEPT
redcli config update auto_config --debug eb_scrubber_interval=86400
sleep $SLEEPT
redcli config update auto_config --debug eb_catcleaner_interval=172800
sleep $SLEEPT
redcli config update auto_config --debug snapshot_resolution_ticks=1073741824
sleep $SLEEPT
redcli config select auto_config
get_user_input

echo "show config"
redcli config show auto_config
redcli config list
redcli config show runtime  -o json > $CONFIG_JSON
cat $CONFIG_JSON | egrep 'compression|gc_horizon_time|reclaim_gc_enabled|reclaim_gc_interval_sec|max_gc_renders_inflight|intentlog_unmap|eb_scrubber_interval|eb_catcleaner_interval|snapshot_resolution_ticks'
