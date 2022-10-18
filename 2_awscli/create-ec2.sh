#!/usr/bin/env bash

set -e

######################################################################
# Variable definition
######################################################################


######################################################################
# Get the AMI_ID
######################################################################


echo "Getting AMI Id..."

EC2_AMI_ID=$(aws ec2 describe-images --output text \
--owners amazon \
--filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*' \
--query 'reverse(sort_by(Images[], &CreationDate))[0].ImageId')

# TODO

echo "Got AMI Id: ${EC2_AMI_ID}"

######################################################################
# Get the VPC Id
######################################################################

echo "Getting VPC Id..."

EC2_VPC_ID=$(aws ec2 describe-vpcs \
--filters 'Name=is-default,Values=true' \
--query 'Vpcs[0].VpcId' \
--output text)

### TODO

echo "Got VPC Id: ${EC2_VPC_ID}"

######################################################################
# Get the Subnet Id within the VPC
######################################################################

echo "Getting Subnet Id..."

EC2_SUBNET_ID=$(aws ec2 describe-subnets --filter "Name=vpc-id,Values=${EC2_VPC_ID}" --query 'Subnets[0].SubnetId' --output text)
### TODO

echo "Got Subnet Id: ${EC2_SUBNET_ID}"

######################################################################
# Get the Security groups Id
######################################################################

echo "Getting Security Group Id..."

### TODO
EC2_SG_ID=$(aws ec2 describe-security-groups --filter "Name=vpc-id,Values=${EC2_VPC_ID}" --query 'SecurityGroups[0].GroupId' --output text)

echo "Got Security Group Id: ${EC2_SG_ID}"

######################################################################
### Provision EC2 Server
######################################################################

echo "Provisioning EC2 instance..."

### TODO

EC2_PROVISION=$(aws ec2 run-instances --image-id ${EC2_AMI_ID} --count 1 --instance-type t2.micro --key-name vockey --security-group-ids ${EC2_SG_ID} --subnet-id ${EC2_SUBNET_ID})

echo "Ec2 Instance ready, here are the details:"
echo ${EC2_PROVISION}
