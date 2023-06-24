#!/bin/bash

cp ~/.kube/config ~/.kube/config_bak

curl -sfL https://get.k3s.io | sh -s - --node-name=homeserver.internal --disable=traefik && sudo cat /etc/rancher/k3s/k3s.yaml >> ~/.kube/config

helm install argo-cd gitops/argo-cd/ --namespace=argocd --create-namespace   && helm template -n argocd gitops/apps | kubectl -n argocd apply -f -
