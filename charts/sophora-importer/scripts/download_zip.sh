# download via s3 if the required env variables are set
if [ -n "$S3_FILE_PATHS" ]; then
  for S3_FILE_PATH in $S3_FILE_PATHS; do
    aws --endpoint="$S3_ENDPOINT" s3 cp "s3://$S3_NAME$S3_FILE_PATH" ./
    echo "Downloaded $S3_FILE_PATH"
  done
fi
