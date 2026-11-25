# helm-charts
Helm charts and configuration for Burp Enterprise used on-prem and in the cloud

## OIDC login for cloud dev PR environments

The `burpsuite` chart's `oidc` block is for the cloud dev PR-environment composition only.
OIDC through this chart is unsupported for on-prem installations and is disabled by default.
Configure it with the manual `BseeInstance` patch in the [Enterprise procedure](https://github.com/portswigger-engineering/enterprise/blob/f98e98e01302c2659dc67d5875b78bc3156e4349/README.md#oidc-login-in-pr-environments).

The composition supplies `oidc`; `oidc.enabled` must be a YAML boolean. Strings, numbers,
arrays and objects are rejected during rendering.

The client Secret must exist in the release namespace. Only the web container mounts its value.
Non-secret settings and `SUPPORTS_OIDC_LOGIN` are passed to web through its ConfigMap.
S3 and `web.enabledProfileFeatures` overrides are retained. Use `web.enabledProfileFeatures`
rather than overriding `ENABLED_PROFILE_FEATURES` through `web.env` or `web.envFrom`.
The application must include generic OIDC support (ENT-12083).

Optional `discoveryUrl`, `scopes` and `groupsClaim` configure generic discovery and claims.
The callback is `https://<first ingress host>/api-internal/oidc/callback`; register that exact URL
with the IdP. `egressHosts` is consumed by the dev composition's network policy, which allows
DNS and HTTPS on port 443 independently of agentic testing. Include every discovery/token/JWKS
host, with no wildcards.
Raw client secrets belong in neither values nor ConfigMaps. The platform operator owns secure
Secret creation, rotation, restart after rotation, and cleanup for each instance namespace.

Run `helm lint charts/*/` and `helm unittest --strict charts/*/` (helm-unittest v0.7.2).
