#!/bin/bash

#install the elasticdump
npm install elasticdump

# migrate the index from the host to the target

export NODE_TLS_REJECT_UNAUTHORIZED=0

./node_modules/elasticdump/bin/elasticdump --input=https://elastic:pass@123@52.157.179.122:9200/cluster_data_index_v1 --output=https://elastic:pass@123@51.124.247.200:9200/cluster_data_index_v1 --type=mapping
./node_modules/elasticdump/bin/elasticdump --input=https://elastic:pass@123@52.157.179.122:9200/cluster_data_index_v1 --output=https://elastic:pass@123@51.124.247.200:9200/cluster_data_index_v1 --type=data

./node_modules/elasticdump/bin/elasticdump --input=https://elastic:pass@123@52.157.179.122:9200/educ_doc_idx --output=https://elastic:pass@123@51.124.247.200:9200/educ_doc_idx --type=mapping
./node_modules/elasticdump/bin/elasticdump --input=https://elastic:pass@123@52.157.179.122:9200/educ_doc_idx --output=https://elastic:pass@123@51.124.247.200:9200/educ_doc_idx --type=data


# migrate the kibana dashboards from the host to the target


curl -X POST "http://52.157.179.122:5601/api/saved_objects/_export" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d' { "type": "dashboard","excludeExportDetails": true,"includeReferencesDeep":true } ' --user $1:$2 -o export_dash.ndjson

curl --location --request POST 'http://51.124.247.200:5601/api/saved_objects/_import?overwrite=true' \
--header 'kbn-xsrf: reporting' \
--user $1:$2 \
--form 'file=@"export_dash.ndjson"'

curl -X POST "http://52.157.179.122:5601/api/saved_objects/_export" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d' { "type": "index-pattern","excludeExportDetails": true } ' --user $1:$2 -o export_index.ndjson

curl --location --request POST 'http://51.124.247.200:5601/api/saved_objects/_import?overwrite=true' \
--header 'kbn-xsrf: reporting' \
--user $1:$2 \
--form 'file=@"export_index.ndjson"'

export NODE_TLS_REJECT_UNAUTHORIZED=1
