# Test Project

A minimal Rust hello-world project used to validate the `pipery-rust-ci` action.

## Contents

- `Cargo.toml` — Cargo package manifest
- `src/main.rs` — Hello-world entry point with unit test

## Building locally

```bash
cargo build --release
./target/release/hello-pipery-rust
cargo test
```
