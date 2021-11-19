# Info

docker pipeline setup

flow :   postgres db -> kafka stream -> flink transformation -> couchbase db
connector:  kafka connector
container:  docker


# docker-compose setup

To start services

$ make compose-up 

To rebuild services

$ make compose-build

To stop services

$ make compose-down

To clean all service

$ make compose-clean

