# CloudNative-PG Helm Chart

Create a PostgreSQL database cluster on AWS EKS using cloudnative-pg.io and any required AWS resources via crossplane.io.

## Version 0.3.0 - Breaking Changes

**Chart version 0.3.0 introduces a breaking change** required for CloudNativePG 1.26+ compatibility.

### What Changed

Chart 0.3.0 migrates from the legacy in-tree backup method (`spec.backup.barmanObjectStore`) to the new Barman Cloud Plugin architecture using a separate `ObjectStore` resource.

**Chart v0.2.x:** Legacy backup via `spec.backup.barmanObjectStore`
**Chart v0.3.0+:** Plugin-based backup via `ObjectStore` resource and `spec.plugins`

### Migration Path

1. **Before upgrading:** Ensure your CloudNativePG operator supports the Barman Cloud Plugin (CNPG 1.20+)
2. **Upgrade:** Deploy chart version 0.3.0
3. **Monitor:** Watch metrics transition from `cnpg_collector_*` to `barman_cloud_*`
4. **Verify:** Confirm backups continue successfully with new plugin method

### Rollback

If issues occur, downgrade to chart version 0.2.x. The S3 backup paths remain unchanged, so existing backups are compatible with both versions.

```bash
helm upgrade <release> portswigger/cloudnative-pg --version 0.2.3
```

### Metrics Changes

| Old Metric (v0.2.x) | New Metric (v0.3.0+) | Notes |
|---------------------|----------------------|-------|
| `cnpg_collector_last_backup_timestamp` | `barman_cloud_cloudnative_pg_io_last_backup_timestamp` | Last successful backup |
| `cnpg_collector_last_failed_backup_timestamp` | `barman_cloud_cloudnative_pg_io_last_failed_backup_timestamp` | Last failed backup |
| `cnpg_backup_duration_seconds` | `cnpg_backup_duration_seconds` | Unchanged |

### S3 Bucket Compatibility

The S3 destination path format is identical between versions:
```
s3://{resourcePrefix}{stackId}/
```

This ensures seamless backup continuity when migrating between chart versions.
