# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.0.1] - 2026-04-27

### Added
- GitHub Marketplace branding icon updated to match action technology (Feather icon set)
- Added `simple_icon` field to `pipery-action.toml` for technology icon reference (Simple Icons slug)

### Added
- Initial implementation of the Rust CI action
- `rust_toolchain` input: selects the Rust toolchain (default `stable`)
- `features` input: enables Cargo feature flags across lint, build, and test steps
- `target` input: sets the Cargo target triple for cross-compilation
- `tests_path` input: filter pattern forwarded to `cargo test`
- `crates_token` input: enables `cargo publish --dry-run` during the release step
- Short git hash (`sha-<7chars>`) included in every release alongside semver tags

### Changed
- All step scripts use `#!/usr/bin/env psh` as the shebang
- `setup-psh.sh` detects runner architecture dynamically (amd64 and arm64)
- Versioning step falls back to editing `Cargo.toml` directly when `pipery-steps` is unavailable

## [0.1.0] - Initial scaffold
