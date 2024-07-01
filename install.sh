#!/bin/bash

set -e

cp ~/.kube/config ~/.kube/config_bak

echo "install apache2-utils for setting argocd password.."
sudo apt install apache2-utils

echo "install k3s.."
curl -sfL https://get.k3s.io | sh -s - --node-name=homeserver.internal --disable=traefik && sudo cat /etc/rancher/k3s/k3s.yaml >> ~/.kube/config

# Required for secrets
mkdir plugins/
echo "install ksops..."
curl -s -L https://github.com/viaduct-ai/kustomize-sops/releases/download/v4.3.1/ksops_4.3.1_Linux_x86_64.tar.gz | tar -xz -C ./plugins
sudo mv ./plugins/ksops /usr/local/bin

# ksops dependency
echo "install kustomize..."
curl -s -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.4.1/kustomize_v5.4.1_linux_amd64.tar.gz | tar -xz -C ./plugins
sudo mv ./plugins/kustomize /usr/local/bin
rm -rf ./plugins

echo "install argocd helm chart..."
helm install argo-cd gitops/argo-cd/ --namespace=argocd --create-namespace && helm template -n argocd gitops/apps | kubectl -n argocd apply -f -

echo "change admin password..."
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "'$(htpasswd -bnBC 10 "" $(sops -d sops_argocd.enc.txt) | tr -d ':\n' | sed 's/$2y/$2a/')'", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'


# Create age keys secrets for ksops to decrypt
cat ~/.config/sops/age/keys.txt | kubectl create secret generic sops-age --namespace=argocd \
--from-file=keys.txt=/dev/stdin -n argocd

