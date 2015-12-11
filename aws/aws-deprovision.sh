#!/bin/bash
# create tags
ids=`./aws-ids all`
echo Deprovisioning: $ids
aws ec2 terminate-instances --instance-ids $ids

date=`date --iso-8601=seconds`
mv provision-data.json log/deprovisioned-$date-pd.json
mv instance-descriptions.json log/deprovisioned-$date-id.json
