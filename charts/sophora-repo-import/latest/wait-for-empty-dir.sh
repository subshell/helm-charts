count_files() {
  result=$(find $1 -type f | grep ".xml" | wc -l)
  echo "$result"
}

currentFileCount=$(count_files /import/admin/incoming)
while [ $currentFileCount -gt 0 ]
do
  echo "Still waiting. Current file count is ${currentFileCount}"
  sleep 1
  currentFileCount=$(count_files /import/admin/incoming)
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

failure=$(count_files /import/admin/failure)

if [ "$failure" -gt 0 ]; then
  # error
  echo "import was not successful"
  echo "failures"
  echo "===="
  ls -R /import/admin/failure
  exit 1
else
  echo "import was successful"
  exit 0
fi
