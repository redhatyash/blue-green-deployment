#!/bin/bash
CURRENT=$(kubectl get svc app-service -o jsonpath='{.spec.selector.version}')
TARGET=$( [ "$CURRENT" = "green" ] && echo "blue" || echo "green" )
kubectl patch service app-service -p '{"spec":{"selector":{"version":"'$TARGET'"}}}'
echo "Rolled back to $TARGET in ~2s."