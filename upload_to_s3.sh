#!/bin/bash

UPLOAD_DIR="/var/www/html/uploads"
BUCKET_NAME="webserver-activity1-bucket2"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")

# Upload files to S3
aws s3 cp "$UPLOAD_DIR" "s3://$BUCKET_NAME/uploads/$TIMESTAMP/" --recursive

# Log the operation
if [ $? -eq 0 ]; then
    echo "$(date): Upload successful" >> /var/log/s3_upload.log
else
    echo "$(date): Upload failed" >> /var/log/s3_upload.log
fi

# Delete files older than one day
#find "$UPLOAD_DIR" -type f -mtime +1 -exec rm {} \;
#find "$UPLOAD_DIR" -type f -mmin +5 -exec rm -f {} +
#find "$UPLOAD_DIR" -type f -mmin +5 -exec rm -f {} \;


FIVE_MINUTES_AGO=$(date -d '-5 minutes' -u +"%Y-%m-%dT%H:%M:%SZ")

# List objects in the bucket and delete those older than 5 minutes
aws s3api list-objects --bucket "$BUCKET_NAME" --query "Contents[?LastModified<'$FIVE_MINUTES_AGO'].Key" --output text | while read -r KEY; do
    aws s3 rm "s3://$BUCKET_NAME/$KEY"
    echo "$(date): Deleted $KEY from S3 bucket" >> /var/log/s3_upload.log
done