# download via s3 if the required env variables are set
if [ -n "$S3_FILE_PATHS" ]; then
  for S3_FILE_PATH in $S3_FILE_PATHS; do
    aws --endpoint="$S3_ENDPOINT" s3 cp "s3://$S3_NAME$S3_FILE_PATH" ./
    echo "Downloaded $S3_FILE_PATH"
  done
fi

# download via http if the required env variables are set
if [ -n "$REPO_ZIP_URLS" ]; then
  for REPO_ZIP_URL in $REPO_ZIP_URLS; do
    wget -q --user="${HTTP_USERNAME}" --password="${HTTP_PASSWORD}" "$REPO_ZIP_URL";
    echo "Downloaded $REPO_ZIP_URL"
  done
fi