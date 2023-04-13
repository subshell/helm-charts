#!/bin/sh

jobStart=$(date +%s%3N)

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
  echo "Waiting for exporter to finish..."
  sleep 10
done
exporterDoneTime=$(date +%s%3N)
exportDurationMillis=$((exporterDoneTime-jobStart))
exportDuration=$(awk -v millis=$exportDurationMillis 'BEGIN { print ( millis / 1000 ) }')
exportedFiles=$(count_files)
# Write metrics to file
cat <<EOT >> /metrics/metrics.txt
# HELP sophora_export_job_start the start unix timestamp of the export job
# TYPE sophora_export_job_start gauge
sophora_export_job_start $jobStart
# HELP sophora_export_job_export_duration_seconds
# TYPE sophora_export_job_export_duration_seconds gauge
sophora_export_job_export_duration_seconds $exportDuration
# HELP sophora_export_job_exported_documents
# TYPE sophora_export_job_exported_documents gauge
sophora_export_job_exported_documents $exportedFiles
EOT

echo "$jobStart" >> /metrics/job_start.txt
