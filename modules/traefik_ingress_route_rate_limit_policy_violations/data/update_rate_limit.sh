#!/bin/bash

# Set the variables
NAMESPACE=${NAMESPACE}
DEPLOYMENT=${DEPLOYMENT_NAME}
ROUTE=${ROUTE_NAME}
LIMIT=${NEW_RATE_LIMIT}

# Update the rate limit
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT -p '{"spec":{"template":{"metadata":{"annotations":{"traefik.ingress.kubernetes.io/rate-limit":"'$LIMIT'"},"labels":{"traefik.http.routers.'$ROUTE'.middlewares":""}}}}}'