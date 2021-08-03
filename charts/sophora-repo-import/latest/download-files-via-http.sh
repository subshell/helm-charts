count_files() {
  result=$(find $1 -type f | wc -l)
  echo "$result"
}

mkdir dl;
cd dl;

jobStart=$(date +%s%3N)
for REPO_ZIP_URL in $REPO_ZIP_URLS; do
  wget -q --user="${HTTP_USERNAME}" --password="${HTTP_PASSWORD}" $REPO_ZIP_URL;
  echo "Downloaded $REPO_ZIP_URL"
done
downloadEnd=$(date +%s%3N)
downloadDurationMillis=$((downloadEnd-jobStart))
downloadDurationSeconds=$(awk -v millis=$downloadDurationMillis 'BEGIN { print ( millis / 1000 ) }')

for file in `ls *.zip`; do unzip $file; done
rm *.zip;
mkdir -p /import/admin/incoming
mkdir -p /import/temp
mkdir -p /import/admin/success
mkdir -p /import/admin/failure
mv * /import/admin/incoming
echo "Copied data to import into local directory /import/admin/incoming"
tree /import/admin/incoming

downloadedFilesCount=$(count_files /import/admin/incoming)

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
sophora_import_job_download_duration_seconds $downloadDurationSeconds
EOT

echo "$jobStart" >> /metrics/job_start.txt
