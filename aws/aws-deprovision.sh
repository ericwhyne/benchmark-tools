#!/bin/bash
# create tags
ids=`./aws-ids all`
echo Deprovisioning: $ids
aws ec2 terminate-instances --instance-ids $ids
