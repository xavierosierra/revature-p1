#!/bin/bash
 resourcegroup=$1
 appname=$2
 storage_acc=$3
 container_name=$4
 databasename=$5

# Create a resource group.
az group create --location southcentralus --name $resourcegroup

# Create an App Service plan 
az appservice plan create \
-n $appname \
-g $resourcegroup \
--is-linux -l "South Central US" \
--sku B1 \
--number-of-workers 3

#Creates storage account 5/4/2019
az storage account create \
--name $storage_acc
-g $resourcegroup \
--location southcentralus \
--sku Standard_GRS \
--kind BlobStorage

#After creating Storage Account we need to create a CONTAINER in the blob  5/4/2019
az storage container create --name $storage_acc

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