## Install

Add age keys to `~/.config/sops/age/keys.txt`

Run `install.sh` (read it first, it overwrites kubeconfig)

Get initial admin secret

`kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n argocd | base64 -d`

## Adding secrets

Encrypt the secret using sops

`sops -e my-resource.yaml > k8s-home/secrets/my-resource.enc.yaml`


### Misc commands

Force ArgoCD resources to be deleted if they get stuck
`kubectl patch crd CRD_NAME -p '{"metadata": {"finalizers": null}}' --type merge`

Restart argocd server
`kubectl --namespace argocd rollout restart deployment argo-cd-argocd-server`

