#!/bin/bash

# Add Seldon Core to an existing kubeflow cluster

PROJECT=${KF_DEV_PROJECT}
NAMESPACE=${KF_DEV_NAMESPACE}
KF_ENV=cloud

cd my-kubeflow

# Generate component
ks generate seldon-serve-simple issue-summarization-model-serving \
  --name=issue-summarization \
  --image=gcr.io/${PROJECT}/issue-summarization-${NAMESPACE}:0.1 \
  --namespace=${NAMESPACE} \
  --replicas=2

# Deploy it to cluster
ks apply ${KF_ENV} -c issue-summarization-model-serving

# Access from local machine
kubectl port-forward $(kubectl get pods -n ${NAMESPACE} -l service=ambassador -o jsonpath='{.items[0].metadata.name}') -n ${NAMESPACE} 8001:80
