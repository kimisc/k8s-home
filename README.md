## Install
Run `install.sh` (read it first, it overwrites kubeconfig)

Get initial admin secret

`kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n argocd | base64 -d`

To access ArgoCD you need to forward the port as there is no ingress rule in place
`kubectl port-forward svc/argo-cd-argocd-server 8080:443`

In case its a remote server you can tunnel the traffic
`ssh -L 8080:localhost:8080 <your-server> -N -v`

### Misc commands

Force ArgoCD resources to be deleted if they get stuck
`kubectl patch crd CRD_NAME -p '{"metadata": {"finalizers": null}}' --type merge`

