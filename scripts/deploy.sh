#!/bin/bash
set -e

IMAGE_TAG=$1
COLOR=$2

echo "Deploying $COLOR with image $IMAGE_TAG"

if [ "$COLOR" == "green" ]; then
  sed "s|IMAGE_PLACEHOLDER|saiy8077/myapp:$IMAGE_TAG|g" k8s/green-deployment.yaml | kubectl apply -f -
  kubectl apply -f k8s/green.yml
else
  kubectl apply -f k8s/blue-deployment.yaml
fi
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/app-$COLOR