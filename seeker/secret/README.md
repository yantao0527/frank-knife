## Kubernetes deploy

- Standalone (default): a single Vault server persisting to a volume using the file storage backend
- High-Availability (HA): a cluster of Vault servers that use an HA storage backend such as Consul (default)

## expose

- Why ingress configuration is not working?
- LoadBalancer is working well.
## Configure Kubernetes authentication

Enable the Kubernetes authentication method.
```
vault auth enable kubernetes
```

Configure the Kubernetes authentication method to use the service account token, the location of the Kubernetes host, and its certificate.
```
vault write auth/kubernetes/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
Success! Data written to: auth/kubernetes/config
```

Write out the policy named webapp that enables the read capability for secrets at path secret/data/webapp/config.
```
vault policy write webapp - <<EOF
path "secret/webapp/config" {
  capabilities = ["read"]
}
EOF
Success! Uploaded policy: webapp
```

Create a Kubernetes authentication role, named webapp, that connects the Kubernetes service account name and webapp policy.
```
vault write auth/kubernetes/role/webapp \
        bound_service_account_names=vault \
        bound_service_account_namespaces=vault \
        policies=webapp \
        ttl=24h
Success! Data written to: auth/kubernetes/role/webapp
```

kubernetes-external-secrets
```
vault write auth/kubernetes/role/webapp \
        bound_service_account_names=external-secrets-kubernetes-external-secrets \
        bound_service_account_namespaces=vault \
        policies=webapp \
        ttl=24h
Success! Data written to: auth/kubernetes/role/webapp
```

