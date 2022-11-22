#!/bin/bash

#install the elasticdump
npm install elasticdump

# migrate the index from the host to the target
export NODE_TLS_REJECT_UNAUTHORIZED=0

./node_modules/elasticdump/bin/elasticdump --input=https://$1:$2@$3:9200/cluster_data_index_v1 --output=https://$4:$5@$6:9200/cluster_data_index_v1 --type=mapping
./node_modules/elasticdump/bin/elasticdump --input=https://$1:$2@$3:9200/cluster_data_index_v1 --output=https://$4:$5@$6:9200/cluster_data_index_v1 --type=data

./node_modules/elasticdump/bin/elasticdump --input=https://$1:$2@$3:9200/educ_doc_idx --output=https://$4:$5@$6:9200/educ_doc_idx --type=mapping
./node_modules/elasticdump/bin/elasticdump --input=https://$1:$2@$3:9200/educ_doc_idx --output=https://$4:$5@$6:9200/educ_doc_idx --type=data

# migrate the kibana dashboards from the host to the target

curl -X POST http://$3:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d' { "type": "dashboard","excludeExportDetails": true,"includeReferencesDeep":true } ' --user $1:$2 -o export_dash.ndjson

curl --location --request POST http://$6:5601/api/saved_objects/_import?overwrite=true \
--header 'kbn-xsrf: reporting' \
--user $4:$5 \
--form 'file=@"export_dash.ndjson"'

curl -X POST http://$3:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d' { "type": "index-pattern","excludeExportDetails": true } ' --user $1:$2 -o export_index.ndjson

curl --location --request POST http://$6:5601/api/saved_objects/_import?overwrite=true \
--header 'kbn-xsrf: reporting' \
--user $4:$5 \
--form 'file=@"export_index.ndjson"'

export NODE_TLS_REJECT_UNAUTHORIZED=1
