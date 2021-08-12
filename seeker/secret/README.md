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
path "secret/data/webapp/config" {
  capabilities = ["read"]
}
EOF
Success! Uploaded policy: webapp
```

Create a Kubernetes authentication role, named webapp, that connects the Kubernetes service account name and webapp policy.
```
vault write auth/kubernetes/role/webapp \
        bound_service_account_names=vault \
        bound_service_account_namespaces=default \
        policies=webapp \
        ttl=24h
Success! Data written to: auth/kubernetes/role/webapp
```