# helm-charts
Helm charts and configuration for Burp Enterprise used on-prem and in the cloud

## OIDC login

The `burpsuite` chart accepts an `oidc` block, disabled by default:

```yaml
oidc:
  enabled: true
  issuer: https://idp.example/realms/dast-test
  clientId: dast-pr-test
  clientSecretRef:
    name: oidc-test-client
    key: client-secret
  egressHosts: [idp.example]
```

The client Secret must exist in the release namespace. Only the web container mounts its value.
Non-secret settings and `SUPPORTS_OIDC_LOGIN` are passed to web through its ConfigMap.
S3 and `web.enabledProfileFeatures` overrides are retained. Use `web.enabledProfileFeatures`
rather than overriding `ENABLED_PROFILE_FEATURES` through `web.env` or `web.envFrom`.
The application must include generic OIDC support (ENT-12083).

Optional `discoveryUrl`, `scopes` and `groupsClaim` configure generic discovery and claims.
The callback is `https://<first ingress host>/api-internal/oidc/callback`; register that exact URL
with the IdP. `egressHosts` is consumed by the dev composition's network policy, which allows
DNS and HTTPS on port 443 independently of agentic testing. Include every discovery/token/JWKS
host, with no wildcards. Production network access needs its platform owner's configuration.
Raw client secrets belong in neither values nor ConfigMaps. The platform operator owns secure
Secret creation, rotation, restart after rotation, and cleanup for each instance namespace.

Run `helm lint charts/*/` and `helm unittest --strict charts/*/` (helm-unittest v0.7.2).
