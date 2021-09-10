#!/bin/bash

sleep 70

echo "initializing kafkaconnector..."
curl -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' kafkaconnect:8083/connectors/ -d '
{
"name": "inventory-connector",
"config": {
"connector.class": "io.debezium.connector.postgresql.PostgresConnector",
"tasks.max": "1",
"database.hostname": "postgres1",
"database.port": "5432",
"database.user": "postgres",
"database.password": "postgres",
"database.dbname" : "inventory",
"database.server.name": "dbserver1",
"database.whitelist": "inventory",
"database.history.kafka.bootstrap.servers": "kafka1:9092",
"database.history.kafka.topic": "Customer",
"plugin.name":"pgoutput",
"key.ignore": "true",
"key.converter": "org.apache.kafka.connect.json.JsonConverter",
"value.converter": "org.apache.kafka.connect.json.JsonConverter",
"key.converter.schemas.enable": "false",
"value.converter.schemas.enable": "false",
"internal.key.converter": "org.apache.kafka.connect.json.JsonConverter",
"internal.value.converter": "org.apache.kafka.connect.json.JsonConverter",
"internal.key.converter.schemas.enable": "false",
"internal.value.converter.schemas.enable": "false",
"transforms": "Reroute,FilterFieldsForUpdate,SetFieldsToUpdate",
"transforms.Reroute.type": "io.debezium.transforms.ByLogicalTableRouter",
"transforms.Reroute.topic.regex": "(.*)(.*)",
"transforms.Reroute.topic.replacement": "Customer",
"transforms.FilterFieldsForUpdate.whitelist": "after",
"transforms.FilterFieldsForUpdate.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
"transforms.SetFieldsToUpdate.renames": "after:data",
"transforms.SetFieldsToUpdate.type": "org.apache.kafka.connect.transforms.ReplaceField$Value"
}
}' | tac | tac 
