#!/bin/sh
name=rumbl-postgres
id=$(docker ps -aq -f name=$name)

if [ -z "$id" ]; then
    echo "Container not available"
    docker run --name $name -p 5432:5432 postgres:9.6.1-alpine
else
    echo "Container found starting if needed"
    started=$(docker inspect -f {{.State.Running}} $id)
    if [ "$started" = "true" ]; then
        echo "Container already running"
    else
        docker start $id
    fi
fi



