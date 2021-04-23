#!/bin/sh

RETRIES=100

count_files() {
  count=$(find /data-export | grep -c ".xml")
  echo "$count"
}

currentFileCount=$(count_files)
while [ "$currentFileCount" -lt 1 ]
do
  if [ "$RETRIES" -lt 1 ]; then
    exit 1
  fi
  RETRIES=$((RETRIES-1))
  echo "Still waiting for exporter to export at least one file. ${RETRIES} tries left"
  sleep 10
  currentFileCount=$(count_files)
done

# wait while exporter is running
while [[ -n "$(pgrep java)" ]]; do
  pgrep java
  echo "Waiting for exporter..."
  sleep 10
done
