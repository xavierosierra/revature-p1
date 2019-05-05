#!/bin/bash
 resourcegroup=$1
 appname=$2
 storage_acc=$3
 container_name=$4
 blobName=$5
 databasename=$6

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
--name $storage_acc
-g $resourcegroup \
--location southcentralus \
--sku Standard_GRS \
--kind BlobStorage

#After creating Storage Account we need to create a CONTAINER in the blob  5/4/2019
az storage container create --name $storage_acc --fail-on-exist

# Create a web app.
az webapp create \
--name $appname \
--resource-group $resourcegroup \
--plan $appname

# Create a SQL API Cosmos DB account with session consistency and multi-master enabled 5/5/2019
az cosmosdb create \
    --resource-group $resourcegroup \
    --name $appname \
    --kind GlobalDocumentDB \
    --location "South Central US"
    --default-consistency-level "Session" \
    --enable-multiple-write-locations true


# Create a database
az cosmosdb database create \
    --resource-group $resourcegroup \
    --name $appname \
    --db-name $databasename


# Create a SQL API container with a partition key and 1000 RU/s
az cosmosdb collection create \
    --resource-group $resourcegroup \
    --collection-name $container_name \
    --name $appname \
    --db-name $databasename \
    --partition-key-path /mypartitionkey \
    --throughput 1000



# #Create a deployment slot with the name "staging".
# az webapp deployment slot create \
# --name $appname \
# --resource-group $resourcegroup \
# --slot staging

# # Deploy sample code to "staging" slot from GitHub.
# az webapp deployment source config --name $appname --resource-group $resourcegroup \
# --slot staging --repo-url $gitrepo --branch master --manual-integration

# # Copy the result of the following command into a browser to see the staging slot.
# echo http://$webappname-staging.azurewebsites.net

# # Swap the verified/warmed up staging slot into production.appname
# az webapp deployment slot swap \
# --name $appname \
# --resource-group $resourcegroup \
# --slot staging

# # Copy the result of the following command into a browser to see the web app in the production slot.
# echo http://$webappname.azurewebsites.net
