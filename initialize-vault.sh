#!/bin/bash

# Set Namespace and Pod Names
NAMESPACE="vault"
VAULT_POD_0="vault-0"
VAULT_POD_1="vault-1"
VAULT_POD_2="vault-2"
VAULT_ACTIVE="http://vault-active:8200"

count=0

# INITIALIZE=$(kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault status | grep Initialized | awk '{print $2}')
# SEALED=$(kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault status | grep Sealed | awk '{print $2}')

STATUS_OUTPUT=$(kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault status -format=json)
INITIALIZE=$(echo $STATUS_OUTPUT | jq -r '.initialized')
SEALED=$(echo $STATUS_OUTPUT | jq -r '.sealed')

echo "INITIALIZE=$INITIALIZE"
echo "SEALED=$SEALED"

while [ $count -lt 2 ]
do

  if [[ "$INITIALIZE" = "false" && "$SEALED" = "true" ]]; then  

    if [ $count == 0 ]; then
      # Initialize and Unseal Vault on vault-0
      echo "Initializing Vault on $VAULT_POD_0..."
      INIT_OUTPUT=$(kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault operator init -n 1 -t 1 -format=json)
      UNSEAL_KEY=$(echo $INIT_OUTPUT | jq -r '.unseal_keys_b64[0]')
      ROOT_TOKEN=$(echo $INIT_OUTPUT | jq -r '.root_token')

      echo "Unseal Key: $UNSEAL_KEY"
      echo "Root Token: $ROOT_TOKEN"

      echo "Unsealing Vault on $VAULT_POD_0..."
      kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault operator unseal $UNSEAL_KEY

      echo "Checking status of Vault on $VAULT_POD_0..."
      kubectl exec -it $VAULT_POD_0 -n $NAMESPACE -- vault status
    else
      # Join and Unseal Vault on vault-1
      echo "Joining and unsealing Vault on $VAULT_POD_1..."
      kubectl exec -it $VAULT_POD_1 -n $NAMESPACE -- vault operator raft join $VAULT_ACTIVE
      kubectl exec -it $VAULT_POD_1 -n $NAMESPACE -- vault operator unseal $UNSEAL_KEY
      # kubectl exec -it $VAULT_POD_1 -n $NAMESPACE -- exit

      # Join and Unseal Vault on vault-2
      echo "Joining and unsealing Vault on $VAULT_POD_2..."
      kubectl exec -it $VAULT_POD_2 -n $NAMESPACE -- vault operator raft join $VAULT_ACTIVE
      kubectl exec -it $VAULT_POD_2 -n $NAMESPACE -- vault operator unseal $UNSEAL_KEY
      # kubectl exec -it $VAULT_POD_2 -n $NAMESPACE -- exit

    fi
  fi

  ((count++))
    
done

echo "Vault cluster setup complete."

sleep 10

kubectl get po -n $NAMESPACE