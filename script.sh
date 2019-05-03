#!/bin/bash
resourcegroup=$1
vmdisk=$2
vmname=$3
adminusername=$4
scaleset=$5

az group create -n $resourcegroup -l southcentralus 
az disk create -g $resourcegroup --name $vmdisk --size-gb 30 --os-type Linux

#create scale set
az vmss create \
  --resource-group $resourcegroup \
  --name myScaleSet \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --generate-ssh-keys
#create the disk

#create the vms within the vm is attach the disks and mount them

az vm create --resource-group $resourcegroup --name $vmname \
--image UbuntuLTS --generate-ssh-keys --attach-data-disks $vmdisk --custom-data './webconfig.txt' --admin-username $adminusername 



az vm disk  detach -n $vmname -g $resourcegroup  --vm-name $vmdisk

scp index.js $adminusername@$id:/home/project1/
#Creating Image

az vm deallocate --resource-group $resourcegroup --name $vmname
az vm generalize --resource-group myResourceGroup --name myVM
az image create --resource-group myResourceGroup --name myImage --source myVM

az vm create -g $resourcegroup -n $vmname --attach-data-disks $vmdisk --admin-username $adminusername --custom-data './webconfig.txt' --image UbuntuLTS --generate-ssh-keys

#try to get the IP and bring it to adminusername@id
id=$( az vm show -g resourcegroup -n $vmname -d --query [].publicIps | grep -E $ip )
adminusername=$( az vm show -g $resourcegroup -n $vmname -d --query [].name | grep -E $adminusername )

ssh $adminusername1@$id

#az vm open-port --port 8080

