# Security Notes

## CodeQL Findings (Not Addressed in This PR)

During the security scan, CodeQL identified 10 alerts related to missing workflow permissions across all workflow files. These are **pre-existing security issues** that were already present in the IaCTofu branch.

### Issue
All workflows are missing explicit `permissions` blocks for the `GITHUB_TOKEN`, which means they have default permissions that may be overly broad.

### Recommendation
These should be addressed in a separate PR to add explicit permissions to each workflow. For example:

```yaml
jobs:
  terraform-docs:
    runs-on: ubuntu-latest
    permissions:
      contents: write  # Only needed if pushing changes
      # Or use: contents: read  # For read-only workflows
```

### Why Not Fixed Here
This PR focuses specifically on fixing the infinite loop in the docs workflow. The permission issues are unrelated security concerns that should be addressed separately to:
1. Keep changes minimal and focused
2. Allow proper review of security permission changes
3. Avoid scope creep

### Files Affected
- `.github/workflows/security_scan.yml`
- `.github/workflows/docker_scans.yml`
- `.github/workflows/docker_build.yml`
- `.github/workflows/docs.yml`
- `.github/workflows/tofu_deploy.yml`
- `.github/workflows/tofu_scan.yml`
- `.github/workflows/tofu_validate.yml`
