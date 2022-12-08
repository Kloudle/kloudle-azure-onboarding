#!/bin/bash

# Created by Riyaz Walikar @Kloudle
# Copyright Kloudle Inc. 2022
# Usage post: https://kloudle.com/blog/how-to-onboard-azure-to-kloudle

echo "Kloudle Azure onboarding script"
echo "Creates a Service Principal with Reader permissions and prints data that will be used to onboard to Kloudle"
echo 

# Obtain subscription id
export SUBSCRIPTION_ID=$(az account show --output json --query 'id' | tr -d '"' )
export SCOPE="/subscriptions/$SUBSCRIPTION_ID"
export APP_NAME="kloudle-reader-app"

# create a SP and obtain App ID and secret
export RAW=$(az ad sp create-for-rbac --name $APP_NAME --role reader --scopes "$SCOPE" --output json 2>/dev/null)

export APP_ID=$(echo $RAW | jq .appId | tr -d '"' )
export APP_SECRET=$(echo $RAW | jq .password)
export TENANT_ID=$(echo $RAW | jq .tenant)

# Assign additional reader roles, as Storage Account and Security Info is unavailable with only Reader
az role assignment create --role "Reader and Data Access" --scope "$SCOPE" --assignee $APP_ID --output none
az role assignment create --role "Security Reader" --scope "$SCOPE" --assignee $APP_ID --output none

# Print data, provide this to Kloudle
echo "tenant_id = $TENANT_ID"
echo "subscription_id = $SUBSCRIPTION_ID"
echo "client_id = $APP_ID"
echo "client_secret = $APP_SECRET"