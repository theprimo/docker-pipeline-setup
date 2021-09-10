#!/bin/bash

sleep 100

echo "Creating couchbase cluster..."

/opt/couchbase/bin/couchbase-cli cluster-init -c couchbase1:8091 --cluster-username Administrator --cluster-password password --services data,index,query,eventing,fts --cluster-ramsize 2048 --cluster-index-ramsize 512 --cluster-eventing-ramsize 256 --cluster-fts-ramsize 256 --index-storage-setting default

echo "Creating data bucket..."

/opt/couchbase/bin/couchbase-cli bucket-create -c couchbase1:8091 -u Administrator -p password --bucket=data --bucket-type=couchbase --bucket-ramsize=512 --bucket-replica=1 --bucket-eviction-policy=fullEviction --compression-mode=active --wait

echo "Creating LifeAsia bucket..."

/opt/couchbase/bin/couchbase-cli bucket-create -c couchbase1:8091 -u Administrator -p password --bucket=LifeAsia --bucket-type=couchbase --bucket-ramsize=512 --bucket-replica=1 --bucket-eviction-policy=fullEviction --compression-mode=active --wait

echo "Creating schema bucket..."

/opt/couchbase/bin/couchbase-cli bucket-create -c couchbase1:8091 -u Administrator -p password --bucket=schema --bucket-type=couchbase --bucket-ramsize=512 --bucket-replica=1 --bucket-eviction-policy=fullEviction --compression-mode=active --wait

sleep 10
./opt/couchbase/bin/cbq -e couchbase1:8093 -u Administrator -p password --script="CREATE PRIMARY INDEX index_data ON \`data\`"

sleep 3
./opt/couchbase/bin/cbq -e couchbase1:8093 -u Administrator -p password --script="CREATE PRIMARY INDEX index_lifeasia ON \`LifeAsia\`"

sleep 3
./opt/couchbase/bin/cbq -e couchbase1:8093 -u Administrator -p password --script="CREATE PRIMARY INDEX index_schema ON \`schema\`" 

sleep 3
/opt/couchbase/bin/couchbase-cli server-list -c couchbase1:8091 --username Administrator --password password

/opt/couchbase/bin/couchbase-cli bucket-list -c couchbase1:8091 --username Administrator --password password
