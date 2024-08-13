#!/bin/bash

BUCKET_NAME="gsn-assignment"
UPLOAD_DIR="/var/www/html/uploads"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
LOG_FILE="/var/log/s3_upload.log"

# Upload files
aws s3 sync $UPLOAD_DIR s3://$BUCKET_NAME/uploads/$TIMESTAMP/ >> $LOG_FILE 2>&1

# Delete old files (older than 1 day)
aws s3 ls s3://$BUCKET_NAME/uploads/ | while read -r line; do
    FILE_DATE=$(echo $line | awk '{print $1}')
    FILE_DATE=$(date -d $FILE_DATE +%s)
    CURRENT_DATE=$(date +%s)
    DIFF=$(( (CURRENT_DATE - FILE_DATE) / 86400 ))
    if [ $DIFF -gt 1 ]; then
        aws s3 rm s3://$BUCKET_NAME/uploads/ --recursive --exclude "*" --include "$line" >> $LOG_FILE 2>&1
    fi
done
