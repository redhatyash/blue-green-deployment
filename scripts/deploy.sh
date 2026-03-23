#!/bin/bash
set -e

IMAGE_TAG=$1
COLOR=$2

echo "Deploying $COLOR with image $IMAGE_TAG"

if [ "$COLOR" == "green" ]; then
  sed "s|IMAGE_PLACEHOLDER|myorg/myapp:$IMAGE_TAG|g" k8s/green.yaml | kubectl apply -f -
else
  kubectl apply -f k8s/blue.yaml
fi

kubectl rollout status deployment/app-$COLOR