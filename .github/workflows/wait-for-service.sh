#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Usage: $0 service_name compose_file_path [compose_file_path...]"
  exit 1
fi
service_name=$1
shift
compose_file_paths=$@

timeout=30
while true; do
  status=$(docker compose -f "${compose_file_paths}" ps "${service_name}" | grep "${service_name}" | awk '{print $6}')
  if [ "${status}" == "Up" ]; then
    echo "Service '${service_name}' is running"
    exit 0
  fi
  timeout=$((timeout-1))

  if [ $timeout -eq 0 ]; then
    echo "Timed out waiting for service '${service_name}' to start"
    exit 1
  fi
  sleep 1
done
