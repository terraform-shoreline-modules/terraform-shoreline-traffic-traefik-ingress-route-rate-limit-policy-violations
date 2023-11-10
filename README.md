
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Traefik Ingress Route Rate Limit Policy Violations

Traefik Ingress Route Rate Limit Policy Violations occur when there are breaches of the rate limit policies set in Traefik-managed routes. Traefik is a popular open-source reverse proxy and load balancer software that is used in Kubernetes environments to provide routing and load balancing capabilities. When a rate limit policy is violated, it means that the allowed rate of requests has been exceeded, which can cause service degradation or outage. This incident type usually requires investigation and remediation to ensure that the rate limit policies are properly configured and enforced.

### Parameters

```shell
export NAMESPACE="PLACEHOLDER"
export TRAEFIK_POD_NAME="PLACEHOLDER"
export INGRESS_ROUTE_NAME="PLACEHOLDER"
export TRAEFIK_DEPLOYMENT_NAME="PLACEHOLDER"
export DEPLOYMENT_NAME="PLACEHOLDER"
export NEW_RATE_LIMIT="PLACEHOLDER"
export ROUTE_NAME="PLACEHOLDER"
```

## Debug

### List all namespaces

```shell
kubectl get namespaces
```

### List all Traefik pods in the current namespace

```shell
kubectl get pods -n ${NAMESPACE} -l app=traefik
```

### Check the logs of a Traefik pod to see if there are any rate limit policy violations

```shell
kubectl logs ${TRAEFIK_POD_NAME} -n ${NAMESPACE} | grep "Rate limit policy violation"
```

### Check the status of the Ingress routes in the current namespace

```shell
kubectl get ingress -n ${NAMESPACE}
```

### Describe a specific Ingress route to see if there are any rate limit policies set

```shell
kubectl describe ingress ${INGRESS_ROUTE_NAME} -n ${NAMESPACE}
```

### Check the annotations of a specific Ingress route to see if there are any rate limit policies set

```shell
kubectl get ingress ${INGRESS_ROUTE_NAME} -n ${NAMESPACE} -o jsonpath='{.metadata.annotations}'
```

### Check the configuration of the Traefik deployment to ensure that rate limit policies are correctly configured

```shell
kubectl describe deployment ${TRAEFIK_DEPLOYMENT_NAME} -n ${NAMESPACE}
```

## Repair

### Increase the rate limit for the affected routes to accommodate the incoming traffic.

```shell
#!/bin/bash

# Set the variables
NAMESPACE=${NAMESPACE}
DEPLOYMENT=${DEPLOYMENT_NAME}
ROUTE=${ROUTE_NAME}
LIMIT=${NEW_RATE_LIMIT}

# Update the rate limit
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT -p '{"spec":{"template":{"metadata":{"annotations":{"traefik.ingress.kubernetes.io/rate-limit":"'$LIMIT'"},"labels":{"traefik.http.routers.'$ROUTE'.middlewares":""}}}}}'
```