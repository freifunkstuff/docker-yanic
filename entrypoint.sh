#!/bin/bash
set -e

# check required env variables
: "${INFLUXDB_URL:? must be set}"

# set some defaults
: "${INFLUXDB_DATABASE:=nodes}"

mkdir -p /config /data /data/meshviewer
cat << EOF > "/config/yanic.toml"

# Send respondd request to update information
[respondd]
enable           = true
# Delay startup until a multiple of the period since zero time
synchronize      = "1m"
# how often request per multicast
collect_interval = "1m"

[respondd.sites.l]
domains = []

[respondd.sites.m]
domains = ["meshkit"]

[[respondd.interfaces]]
ifname = "bat0"
multicast_address = "ff02::2:1001"

[[respondd.interfaces]]
ifname = "bat0"
multicast_address = "ff05::2:1001"

[[respondd.interfaces]]
ip_address = "0.0.0.0"
send_no_request = true
port = 10011

[webserver]
enable  = false

[nodes]
state_path    = "/data/state.json"
prune_after   = "120d"
save_interval = "5s"
offline_after = "1h"

# definition for the new more compressed meshviewer.json
[[nodes.output.meshviewer]]
enable   = true
path = "/data/meshviewer/meshviewer.json"

[nodes.output.meshviewer.filter]
# WARNING: if it is not set to true, it will publish contact information of other persons
no_owner = false

[[nodes.output.nodelist]]
enable = false

[database]
delete_after    = "60d"
delete_interval = "1h"

[[database.connection.influxdb]]
enable   = true
address  = "${INFLUXDB_URL}"
database = "${INFLUXDB_DATABASE}"
username = ""
password = ""

[[database.connection.graphite]]
enable   = false

[[database.connection.respondd]]
enable   = false

[[database.connection.logging]]
enable = false

EOF

exec /bin/yanic serve --config /config/yanic.toml
