# Pipery Rust CI

CI pipeline for Rust: SAST, SCA, lint, build, test, versioning, packaging, release, reintegration

## Status

- Owner: `pipery-dev`
- Repository: `pipery-rust-ci`
- Marketplace category: `continuous-integration`
- Current version: `0.1.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-rust-ci@v0
        with:
          project_path: .
```

## Inputs

### Core

| Name | Default | Description |
|---|---|---|
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.github/pipery/config.yaml` | Path to Pipery config file. |
| `log_file` | `pipery.jsonl` | Path to the JSONL log file written during the run. |
| `rust_toolchain` | `stable` | Rust toolchain to use (e.g. `stable`, `nightly`, `1.75`). |
| `features` | `` | Cargo features to enable (comma-separated). |
| `target` | `` | Cargo target triple (e.g. `x86_64-unknown-linux-musl`). |

### Credentials

| Name | Default | Description |
|---|---|---|
| `github_token` | `` | GitHub token for release and reintegration steps. |
| `crates_token` | `` | crates.io API token for publishing. |

### Pipeline controls (skip flags)

| Name | Default | Description |
|---|---|---|
| `skip_sast` | `false` | Skip SAST step. |
| `skip_sca` | `false` | Skip SCA step. |
| `skip_lint` | `false` | Skip lint step. |
| `skip_build` | `false` | Skip build step. |
| `skip_test` | `false` | Skip test step. |
| `skip_versioning` | `false` | Skip versioning step. |
| `skip_packaging` | `false` | Skip packaging step. |
| `skip_release` | `false` | Skip release step. |
| `skip_reintegration` | `false` | Skip reintegration step. |

### Versioning & release

| Name | Default | Description |
|---|---|---|
| `version_bump` | `patch` | Version bump type: `patch`, `minor`, or `major`. |
| `target_branch` | `main` | Target branch for reintegration. |

### Testing

| Name | Default | Description |
|---|---|---|
| `tests_path` | `` | Test filter pattern passed to `cargo test`. |

## Steps

| Step | Skip flag | What it does |
|---|---|---|
| Lint | `skip_lint` | Runs `cargo clippy` with `-D warnings`; installs clippy component if missing |
| SAST | `skip_sast` | Static analysis via `pipery-steps sast --language rust`; falls back to `cargo audit` |
| SCA | `skip_sca` | Dependency vulnerability scan via `pipery-steps sca --language rust`; falls back to `cargo audit` |
| Build | `skip_build` | `cargo build --release` with optional `--target` and `--features`; copies binaries to `dist/` |
| Test | `skip_test` | `cargo test` with optional test filter and features |
| Versioning | `skip_versioning` | Bumps version via `pipery-steps version` or edits `Cargo.toml` directly; writes to `GITHUB_OUTPUT` |
| Packaging | `skip_packaging` | `cargo package` to create `.crate` file, copies to `dist/` |
| Release | `skip_release` | Publishes GitHub release; runs `cargo publish --dry-run` if `crates_token` is set |
| Reintegration | `skip_reintegration` | Merges release branch back to `target_branch` |

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions release --repo . --dry-run
```
