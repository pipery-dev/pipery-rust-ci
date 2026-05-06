# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-rust-ci/main/assets/icon.png" alt="Pipery Rust CI" width="28" align="center" /> Pipery Rust CI

Reusable GitHub Action for a complete Rust CI pipeline with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Rust%20CI-blue?logo=github)](https://github.com/marketplace/actions/pipery-rust-ci)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-rust-ci@v1
        with:
          project_path: .
          crates_token: ${{ secrets.CRATES_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Pipeline Overview

| Step | Tool | Skip Input | Description |
| --- | --- | --- | --- |
| Lint | rustfmt, clippy | `skip_lint` | Enforces code style and linting rules |
| SAST | cargo-audit | `skip_sast` | Detects Rust security vulnerabilities |
| SCA | cargo-deny | `skip_sca` | Identifies vulnerable dependencies |
| Build | cargo build | `skip_build` | Compiles Rust project |
| Test | cargo test | `skip_test` | Runs unit and integration tests |
| Version | Semantic versioning | `skip_versioning` | Bumps version and creates git tag |
| Package | cargo build --release | `skip_packaging` | Creates release binary |
| Release | crates.io publish | `skip_release` | Publishes to crates.io |
| Reintegrate | Git merge | `skip_reintegration` | Merges back to default branch |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `rust_toolchain` | `stable` | Rust toolchain to use (e.g., `stable`, `nightly`, `1.75`). |
| `tests_path` | `` | Test filter pattern passed to cargo test. |
| `features` | `` | Cargo features to enable (comma-separated). |
| `target` | `` | Cargo target triple (e.g., `x86_64-unknown-linux-musl`). |
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `target_branch` | `main` | Target branch for reintegration. |
| `crates_token` | `` | crates.io API token for publishing. |
| `github_token` | `` | GitHub token for release and reintegration. |
| `log_file` | `pipery.jsonl` | Path to the JSONL structured log file. |
| `skip_lint` | `false` | Skip the lint step. |
| `skip_sast` | `false` | Skip the SAST step. |
| `skip_sca` | `false` | Skip the SCA step. |
| `skip_build` | `false` | Skip the build step. |
| `skip_test` | `false` | Skip the test step. |
| `skip_versioning` | `false` | Skip the versioning step. |
| `skip_packaging` | `false` | Skip the packaging step. |
| `skip_release` | `false` | Skip the release step. |
| `skip_reintegration` | `false` | Skip the reintegration step. |

## Usage Examples

### Example 1: Standard Rust crate with stable toolchain

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-rust-ci@v1
        with:
          project_path: .
          rust_toolchain: stable
          crates_token: ${{ secrets.CRATES_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 2: Nightly Rust with features enabled

```yaml
- uses: pipery-dev/pipery-rust-ci@v1
  with:
    project_path: .
    rust_toolchain: nightly
    features: serde,tokio,macros
    crates_token: ${{ secrets.CRATES_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 3: Cross-compile to musl target

```yaml
- uses: pipery-dev/pipery-rust-ci@v1
  with:
    project_path: .
    rust_toolchain: stable
    target: x86_64-unknown-linux-musl
    crates_token: ${{ secrets.CRATES_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 4: Run specific integration tests

```yaml
- uses: pipery-dev/pipery-rust-ci@v1
  with:
    project_path: .
    tests_path: integration_test
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Example 5: Skip security checks for development

```yaml
- uses: pipery-dev/pipery-rust-ci@v1
  with:
    project_path: .
    skip_sast: true
    skip_sca: true
    skip_release: true
```

### Example 6: Major version bump for release

```yaml
- uses: pipery-dev/pipery-rust-ci@v1
  with:
    project_path: .
    rust_toolchain: stable
    version_bump: major
    crates_token: ${{ secrets.CRATES_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-rust-ci/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `CRATES_TOKEN` - crates.io authentication token
- `GITHUB_TOKEN` - GitHub API access for release and reintegration
- `RUST_TOOLCHAIN` - Rust toolchain (default: stable)
- `VERSION_BUMP` - patch/minor/major (default: patch)

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `CRATES_TOKEN` - crates.io authentication token
   - `GITHUB_TOKEN` - GitHub API access (for release and reintegration)
   - `RUST_TOOLCHAIN` - Rust toolchain (default: stable)
3. Commit and push to trigger the pipeline

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → lint (clippy) → SAST (cargo-audit) → SCA (cargo-deny) → build → test → versioning → packaging → release → reintegration → logs

### Skip Flags

Disable any stage using environment variables:

- `SKIP_LINT`, `SKIP_SAST`, `SKIP_SCA`, `SKIP_BUILD`, `SKIP_TEST`, `SKIP_VERSIONING`, `SKIP_PACKAGING`, `SKIP_RELEASE`, `SKIP_REINTEGRATION`

Example: Set `SKIP_SAST=true` to skip security scanning.

### Features

- Multiple Rust toolchains (stable, nightly, pinned)
- Feature flag testing
- Cross-compilation support
- Cargo security scanning
- Dependency vulnerability checking
- Automatic crates.io publishing
- JSONL-based pipeline logging
- 30-90 day artifact retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
