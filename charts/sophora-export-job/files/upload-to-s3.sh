#!/bin/sh

# see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
# this script requires env variables ZIP_FILE_NAME_DATE_FORMAT, S3_NAME, S3_FILE_PATH_WITHOUT_EXTENSION, S3_ENDPOINT, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and STORE_UPLOAD_PER_WEEKDAY to be set

echo "creating zip"
tree /data-export
cd /data-export || exit
mkdir "/output"
zip -q9rD "/output/export.zip" .

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/mv.html
echo "start uploading to s3..."
uploadStart=$(date +%s%3N)
aws --endpoint="$S3_ENDPOINT" s3 cp "/output/export.zip" "s3://$S3_NAME$S3_FILE_PATH_WITHOUT_EXTENSION.zip"

uploadEnd=$(date +%s%3N)
uploadDurationMillis=$((uploadEnd-uploadStart))
uploadDuration=$(awk -v millis=$uploadDurationMillis 'BEGIN { print ( millis / 1000 ) }')

jobStart=$(cat /metrics/job_start.txt)

jobEnd=$(date +%s%3N)
jobDurationMillis=$((jobEnd-jobStart))
jobDuration=$(awk -v millis=$jobDurationMillis 'BEGIN { print ( millis / 1000 ) }')

# Write metrics to file
cat <<EOT >> /metrics/metrics.txt
# HELP sophora_export_job_upload_duration_seconds
# TYPE sophora_export_job_upload_duration_seconds gauge
sophora_export_job_upload_duration_seconds $uploadDuration
# HELP sophora_export_job_end the end unix timestamp of the export job
# TYPE sophora_export_job_end gauge
sophora_export_job_end{success="true"} $jobEnd
# HELP sophora_export_job_duration_seconds
# TYPE sophora_export_job_duration_seconds gauge
sophora_export_job_duration_seconds $jobDuration
EOT

# Push metrics
if [ -z "$PUSHGATEWAY_BASE_URL" ]; then
  echo "pushgateway url is empty - not pushing metrics"
else
  echo "pushing metrics"
  if [ -z "$PUSHGATEWAY_USERNAME" ]; then
    curl -X PUT -s -H "Content-Type: text/plain" --data-binary "@/metrics/metrics.txt" "$PUSHGATEWAY_BASE_URL/metrics/job/$JOB_NAME"
  else
    curl -X PUT -s -H "Content-Type: text/plain" --user "${PUSHGATEWAY_USERNAME}:${PUSHGATEWAY_PASSWORD}" --data-binary "@/metrics/metrics.txt" "$PUSHGATEWAY_BASE_URL/metrics/job/$JOB_NAME"
  fi
fi
