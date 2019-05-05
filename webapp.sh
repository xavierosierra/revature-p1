#!/bin/bash
resourcegroup=$1
appname=$2

# Replace the following URL with a public GitHub repo URL
gitrepo=https://github.com/xavierosierra/revature-p1.git
webappname=mywebapp$RANDOM

# Create a resource group.
az group create --location southcentralus --name $resourcegroup

# Create an App Service plan in  tier PremiumV2 because it can Autoscale up to 20 instances
az appservice plan create \
-n $appname \
-g $resourcegroup \
--is-linux -l "South Central US" \
--sku P1V2 \
--number-of-workers 3

#Creates storage account 5/4/2019
az storage account create \
--name $appname
--resource-group $resourcegroup \
--location southcentralus \
--sku Standard_GRS \
--kind StorageV2

# Create a web app.
az webapp create \
--name $appname \
--resource-group $resourcegroup \
--plan $appname

#Create a deployment slot with the name "staging".
az webapp deployment slot create \
--name $appname \
--resource-group $resourcegroup \
--slot staging

# Deploy sample code to "staging" slot from GitHub.
az webapp deployment source config --name $appname --resource-group $resourcegroup \
--slot staging --repo-url $gitrepo --branch master --manual-integration

# Copy the result of the following command into a browser to see the staging slot.
echo http://$webappname-staging.azurewebsites.net

# Swap the verified/warmed up staging slot into production.appname
az webapp deployment slot swap \
--name $appname \
--resource-group $resourcegroup \
--slot staging

# Copy the result of the following command into a browser to see the web app in the production slot.
echo http://$webappname.azurewebsites.net
