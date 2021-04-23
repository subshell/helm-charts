#!/bin/sh

# see https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
# this script requires env variables S3_NAME, S3_ABSOLUTE_FILE_PATH, S3_ENDPOINT, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to be set

echo "creating zip"
tree /data-export
cd /data-export || exit
mkdir "/output"
zip -q9rD "/output/export.zip" .

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/mv.html
echo "start uploading to s3..."
aws --endpoint="$S3_ENDPOINT" s3 mv "/output/export.zip" "s3://$S3_NAME$S3_ABSOLUTE_FILE_PATH"
