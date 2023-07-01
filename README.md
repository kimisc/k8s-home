## Install
Run `install.sh` (read it first, it overwrites kubeconfig)

Get initial admin secret

`kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n argocd | base64 -d`

### Misc commands

Force ArgoCD resources to be deleted if they get stuck
`kubectl patch crd CRD_NAME -p '{"metadata": {"finalizers": null}}' --type merge`

