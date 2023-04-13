count_files() {
  result=$(find $1 -type f | grep ".xml" | wc -l)
  echo "$result"
}

cd /sophora || exit
echo "Starting importer."
importerStart=$(date +%s%3N)
java -cp classpath org.springframework.boot.loader.PropertiesLauncher
importerStop=$(date +%s%3N)
echo "Importer stopped."
importDurationMillis=$((importerStop-importerStart))
importDurationSeconds=$(awk -v millis=$importDurationMillis 'BEGIN { print ( millis / 1000 ) }')

success=$(count_files /import/success)
failure=$(count_files /import/failure)

printf "successful imports: %i\t import failures: %i\n" "$success" "$failure"

jobStart=$(cat /metrics/job_start.txt)
jobSuccessful="true"
if [ "$failure" -gt 0 ]; then
  jobSuccessful="false"
fi

jobEnd=$(date +%s%3N)
jobDurationMillis=$((jobEnd-jobStart))
jobDuration=$(awk -v millis=$jobDurationMillis 'BEGIN { print ( millis / 1000 ) }')
# Write metrics to file
cat <<EOT >> /metrics/metrics.txt
# HELP sophora_import_job_end the end unix timestamp of the import job
# TYPE sophora_import_job_end gauge
sophora_import_job_end{success="$jobSuccessful"} $jobEnd
# HELP sophora_import_job_imported_documents
# TYPE sophora_import_job_imported_documents gauge
sophora_import_job_imported_documents{imported="true"} $success
sophora_import_job_imported_documents{imported="false"} $failure
# HELP sophora_import_job_import_duration_seconds
# TYPE sophora_import_job_import_duration_seconds gauge
sophora_import_job_import_duration_seconds $importDurationSeconds
# HELP sophora_import_job_duration_seconds
# TYPE sophora_import_job_duration_seconds gauge
sophora_import_job_duration_seconds{success="$jobSuccessful"} $jobDuration
EOT

exit 0
