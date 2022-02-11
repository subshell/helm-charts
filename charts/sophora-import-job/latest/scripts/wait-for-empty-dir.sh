count_files() {
  result=$(find $1 -type f | grep ".xml" | wc -l)
  echo "$result"
}

currentFileCount=$(count_files /import/incoming)
while [ $currentFileCount -gt 0 ]
do
  echo "Still waiting. Current file count is ${currentFileCount}"
  sleep 1
  currentFileCount=$(count_files /import/incoming)
done

echo "No files remaining. Stopping importer."
# Kill the importer:
importerPid=$(pgrep java)
kill $importerPid

# Wait for importer to stop
tail --pid="$importerPid" -f /dev/null

# Push metrics
if [ -z "$PUSHGATEWAY_BASE_URL" ]; then
  echo "pushgateway url is empty - not pushing metrics"
else
  # give the importer container two seconds to write the metrics
  sleep 2
  echo "pushing metrics"
  if [ -z "$PUSHGATEWAY_USERNAME" ]; then
    curl -X PUT -s -H "Content-Type: text/plain" --data-binary "@/metrics/metrics.txt" "$PUSHGATEWAY_BASE_URL/metrics/job/$JOB_NAME"
  else
    curl -X PUT -s -H "Content-Type: text/plain" --user "${PUSHGATEWAY_USERNAME}:${PUSHGATEWAY_PASSWORD}" --data-binary "@/metrics/metrics.txt" "$PUSHGATEWAY_BASE_URL/metrics/job/$JOB_NAME"
  fi
fi

failure=$(count_files /import/failure)

if [ "$failure" -gt 0 ]; then
  # error
  echo "import was not successful"
  echo "failures"
  echo "===="
  ls -R /import/failure

  if [ -n "$IMPORT_FAILURE_FILES_ENABLED" ]; then
    s3Path="s3://$S3_NAME$S3_FILE_PATH/${MY_POD_NAME}_$(date '+%Y-%m-%d_%H-%M')"
    echo "uploading failure files to configured s3 bucket $s3Path"
    aws --endpoint="$S3_ENDPOINT" s3 cp "/import/failure/" "$s3Path" --recursive
  fi
else
  echo "import was successful"
fi

exit 0