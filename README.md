# Azure Reader Service Principal Creator

## Introduction

This repository contains a bash shell script that creates a service principal within the target Azure subscription, applies the required roles to it and prints the data required for onboarding to Kloudle.

The script does the following

1. Creates a Service Principal as an App registration called `kloudle-reader-app`
2. Adds the `Reader` role to it for Azure account access
3. Adds the `Reader and Data Access` role to it for Storage Account visibility access
4. Adds `Security Reader` role to it for Security attribute visibility across Azure
5. Adds `Website Contributor` role to it for reading Website configurations
6. Adds `Web Plan Contributor` role to it for reading Web Plans for Websites
7. Adds the `Directory.Read.All` Microsoft Graph APIs Application Role Access
8. Adds the `Application.Read.All` and `Directory.Read.All` Windows Azure Active Directory Application Role Access
9. Grants an Admin Consent for the app permissions added so that the Principal can work through the CLI

## Pre-requisites

1. An Azure account that is has Owner privileges to Azure
2. Access to Azure Cloud Shell where this script will be run. The Azure Cloud Shell has all the required tooling for this script to work quickly and without additional configuration.
3. Also ensure you are in the correct Azure account and the correct subscription when logging in. You can confirm this by running `az account show` before running the script

## Usage

**Note: Please run the following command via the Azure Cloud Shell which you can access from the Azure dashboard menu bar**

You can pass the shell script to curl directly using the raw GitHub URL

```bash
curl -sS https://raw.githubusercontent.com/Kloudle/kloudle-azure-onboarding/master/azure-service-principle-creator.sh | sh
```

Share the output with the Kloudle Team or as required, paste the output in the Azure Onboarding page on the Kloudle App.
