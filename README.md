# bakissalabs/.github

Shared configuration for the Bakissa organizations.

- `profile/README.md`: the public profile of [bakissalabs](https://github.com/bakissalabs).
- `.github/workflows/attribution.yml`: fails a pull request or a push whose commits carry an
  attribution line (co-author, tool mention), and a pull request whose description does. On a
  new branch or a force-push, checks every commit no other branch holds. Reads the caller's
  `.githooks/attribution-pattern`, or a built-in default.
- `.github/workflows/gitleaks.yml`: scans the whole history for secrets with a pinned,
  checksum-verified gitleaks. Reads the caller's `.gitleaks.toml` if present.

## Use

```yaml
# .github/workflows/checks.yml
name: checks
on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
  push:
    branches: [main]
permissions:
  contents: read
jobs:
  attribution:
    uses: bakissalabs/.github/.github/workflows/attribution.yml@main
  secrets:
    uses: bakissalabs/.github/.github/workflows/gitleaks.yml@main
```

This repository is public so that every organization can call these workflows: nothing
confidential belongs here.
