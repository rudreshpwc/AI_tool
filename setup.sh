#!/bin/bash

#setting up the MMaps stores shard index to store. https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

sysctl -w vm.max_map_count=262144 

docker compose up -d
