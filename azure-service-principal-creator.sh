#!/bin/bash

# Created by Riyaz Walikar @Kloudle
# Copyright Kloudle Inc. 2022
# Usage post: https://kloudle.com/blog/how-to-onboard-azure-to-kloudle

echo "Kloudle Azure onboarding script"
echo "Creates a Service Principal with Reader permissions and prints data that will be used to onboard to Kloudle"
echo "Data generation in progress. Do not interrupt the script, Azure CLI is known to be slow."
echo 

# Obtain subscription id
export SUBSCRIPTION_ID=$(az account show --output json --query 'id' | tr -d '"' )
export SCOPE="/subscriptions/$SUBSCRIPTION_ID"
export APP_NAME="kloudle-reader-app"

# create a SP and obtain App ID and secret
export RAW=$(az ad sp create-for-rbac --name $APP_NAME --role reader --scopes "$SCOPE" --output json 2>/dev/null)

export APP_ID=$(echo $RAW | jq .appId | tr -d '"')
export APP_SECRET=$(echo $RAW | jq .password | tr -d '"')
export TENANT_ID=$(echo $RAW | jq .tenant | tr -d '"')

# Assign additional reader roles, as Storage Account, Website Contributor and Security Info is unavailable with only Reader
az role assignment create --role "Reader and Data Access" --scope "$SCOPE" --assignee $APP_ID --output none
az role assignment create --role "Security Reader" --scope "$SCOPE" --assignee $APP_ID --output none
az role assignment create --role "Website Contributor" --scope "$SCOPE" --assignee $APP_ID --output none

# Microsoft Graph APIs Application Role Access

az ad app permission add --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --api-permissions 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role # "Directory.Read.All"

az ad app permission grant --id $APP_ID --api 00000003-0000-0000-c000-000000000000 --scope Directory.Read.All

# Windows Azure Active Directory Application Role Access

az ad app permission add --id $APP_ID --api 00000002-0000-0000-c000-000000000000 --api-permissions 3afa6a7d-9b1a-42eb-948e-1650a849e176=Role # "Application.Read.All"
az ad app permission add --id $APP_ID --api 00000002-0000-0000-c000-000000000000 --api-permissions 5778995a-e1bf-45b8-affa-663a9f3f4d04=Role # "Directory.Read.All"

az ad app permission grant --id $APP_ID --api 00000002-0000-0000-c000-000000000000 --scope Application.Read.All,Directory.Read.All

# Grant Admin Consent so that the Principal can work through CLI

az ad app permission admin-consent --id $APP_ID

# Print data, provide this to Kloudle
echo "tenant_id = $TENANT_ID"
echo "subscription_id = $SUBSCRIPTION_ID"
echo "client_id = $APP_ID"
echo "client_secret = $APP_SECRET"