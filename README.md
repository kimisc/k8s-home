## Install

Add ![age keys](https://github.com/FiloSottile/age) to `~/.config/sops/age/keys.txt`

Run `install.sh`

* installs k3s, ksops + kustomize for secret management, argocd and its applications via helm

Get initial admin secret

`kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" -n argocd | base64 -d`

### Adding secrets

Encrypt the secret using sops

`sops -e my-resource.yaml > k8s-home/secrets/my-resource.enc.yaml`

Add it to the `secrets/secret-generator.yaml` files section

### Certificates

Certs are generated with self signed CA certificate using cert-manager. 

`openssl req -newkey rsa:4096 -x509 -sha512 -days 1800 -nodes -out server.pem -keyout ca-key.pem -subj "/C=FI/O=Home Local LAN/CN=homeserver"`

Use the values in `ca-key-pair.yaml`. Values need to be base64 encoded so `cat server.pem | base64 -w0` etc.

```
    apiVersion: v1
    kind: Secret
    metadata:
        name: ca-key-pair
        namespace: cert-manager
    data:
        tls.crt: 
        tls.key:
```


Trust the cert on local machine:

`# trust anchor --store server.pem`

Remove from trusted certs:

`# trust anchor --remove server.pem`

## Uninstall

Run `/usr/local/bin/k3s-uninstall.sh`
