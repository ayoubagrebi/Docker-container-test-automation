#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 compose_file_path"
  exit 1
fi

compose_file_path=$1

services=$(docker-compose -f "${compose_file_path}" config --services)

for service_name in $services; do
  timeout=30
  while true; do
    status=$(docker-compose -f "${compose_file_path}" ps "${service_name}" | grep "${service_name}" | awk '{print $6}')
    if [ "${status}" == "Up" ]; then
      echo "Service '${service_name}' is running"
      break
    fi
    timeout=$((timeout-1))

    if [ $timeout -eq 0 ]; then
      echo "Timed out waiting for service '${service_name}' to start"
      exit 1
    fi
    sleep 1
  done
done
