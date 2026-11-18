# bakissalabs/.github

Shared configuration for the Bakissa organizations.

- `profile/README.md`: the public profile of [bakissalabs](https://github.com/bakissalabs).
- `.github/workflows/checks.yml`: every shared check, in a single job (each job is billed
  rounded up to the minute):
  - attribution: fails a pull request or a push whose commits carry an attribution line
    (co-author, tool mention), and a pull request whose description does. On a new branch or a
    force-push, checks every commit no other branch holds. Reads the caller's
    `.githooks/attribution-pattern`, or a built-in default;
  - secrets: scans the whole history with a pinned, checksum-verified gitleaks. Reads the
    caller's `.gitleaks.toml` if present.

  The job is skipped, before any runner starts, on a push whose head commit GitHub made (a
  pull request merge: the pull request already checked that content), and on a pull request
  edit that changes neither the description nor the base branch.

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
concurrency:
  group: >-
    ${{ github.workflow }}-${{
    github.event_name == 'pull_request'
    && !(github.event.action == 'edited' && !github.event.changes.body && !github.event.changes.base)
    && github.event.pull_request.number
    || github.run_id }}
  cancel-in-progress: true
jobs:
  checks:
    uses: bakissalabs/.github/.github/workflows/checks.yml@v1
```

The `concurrency` block keeps one live run per pull request; a title-only edit and every push
get a group of their own, so they cancel nothing. This repository runs the same file as
`.github/workflows/ci.yml`, with a local `uses: ./.github/workflows/checks.yml`.

## Versions

- Call `@v1`, never `@main`: `main` changes with every merge, and a broken change there would
  break the checks of every caller at once.
- `v1` is a moving tag: a compatible change is released as a new `v1.x.y` tag and `v1` is moved
  onto it.
- An incompatible change (a new required input or secret, a removed check, a stricter rule that
  fails what passed) starts `v2`; `v1` stays where it is.
- Every release also gets an immutable semver tag (`v1.0.0`, `v1.1.0`…) for callers that want
  to pin one.

## Deprecated

`.github/workflows/attribution.yml` and `.github/workflows/gitleaks.yml` are the former
two-job workflows, still called `@main` by existing callers. They stay unchanged until every
caller has moved to `checks.yml@v1`, then they will be removed.

This repository is public so that every organization can call these workflows: nothing
confidential belongs here.
