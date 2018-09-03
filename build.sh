#!/bin/bash
# updating privacy policy
echo 'copying files to s3'
aws s3 cp privacy.html s3://workoutplannerskill/ --acl public-read
