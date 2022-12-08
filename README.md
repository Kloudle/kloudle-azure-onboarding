# Azure Reader Service Principal Creator

## Introduction

This repository contains a bash shell script that creates a service principal within the target Azure subscription, applies the required roles to it and prints the data required for onboarding to Kloudle.

The script does the following

1. Creates a Service Principal as an App registration called `kloudle-reader-app`
2. Adds the `Reader` role to it for Azure account access
3. Adds the `Reader and Data Access` role to it for Storage Account visibility access
4. Adds `Security Reader` role to it for Security attribute visibility across Azure

## Pre-requisites

1. An Azure account that is has Owner privileges to Azure
2. Access to Azure Cloud Shell where this script will be run. The Azure Cloud Shell has all the required tooling for this script to work quickly and without additional configuration.
3. Also ensure you are in the correct Azure account and the correct subscription when logging in. You can confirm this by running `az account show` before running the script

## Usage

You can pass the shell script to curl directly using the raw GitHub URL

```bash
curl -sS https://raw.githubusercontent.com/Kloudle/kloudle-azure-onboarding/master/azure-service-principle-creator.sh | sh
```

Share the output with the Kloudle Team or as required, paste the output in the Azure Onboarding page on the Kloudle App.
