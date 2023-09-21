count_files() {
  result=$(find $1 -type f | grep ".xml" | wc -l)
  echo "$result"
}

downloadEnd=$(date +%s%3N)
downloadDurationMillis=$((downloadEnd-jobStart))
downloadDurationSeconds=$(awk -v millis=$downloadDurationMillis 'BEGIN { print ( millis / 1000 ) }')

for file in `ls *.zip`; do unzip "$file" && rm $file; done
for file in `ls *.tar.gz`; do tar -zxvf "$file" && rm $file; done

mkdir -p /import/incoming
mkdir -p /import/temp
mkdir -p /import/success
mkdir -p /import/failure
mv * /import/incoming
echo "Copied data to import into local directory /import/incoming"
tree /import/incoming

downloadedFilesCount=$(count_files /import/incoming)

# Write metrics to file
cat <<EOT >> /metrics/metrics.txt
# HELP sophora_import_job_start the unix timestamp when the job started
# TYPE sophora_import_job_start gauge
sophora_import_job_start $jobStart
# HELP sophora_import_job_downloaded_documents
# TYPE sophora_import_job_downloaded_documents gauge
sophora_import_job_downloaded_documents $downloadedFilesCount
# HELP sophora_import_job_download_duration_seconds
# TYPE sophora_import_job_download_duration_seconds gauge
sophora_import_job_download_duration_seconds{type="documents"} $downloadDurationSeconds
EOT

echo "$jobStart" >> /metrics/job_start.txt
