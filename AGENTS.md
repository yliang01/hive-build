# AGENTS.md — hive-build

## Scope

- This repository contains only cross-module workspace build and release-assembly tooling. The parent `hive/` directory is a local workspace, not a Git repository; each application module remains its own repository.
- `pom.xml` is the workspace Maven aggregator. It lists sibling module checkouts using paths relative to `hive-build/`; nested aggregators `db2oss` and `hive-encryption` include their children.
- `package-release.cmd` invokes the reactor once, then runs the separate release-directory assembler. It does not change module Git ownership.
- Runtime code, module-specific resources, and release application behavior belong in their owning module repositories. Keep this repository limited to orchestration, shared build tools, and genuinely cross-module packaging templates.
- Never store credentials, encrypted production configuration, or generated release artifacts in this Git repository.

## Workspace assumptions

- Expected sibling directories are `external-bom`, `hive-domain`, `hive-encryption`, `db2oss`, `hive-oss-frontend`, `hive-release`, and `hive-oss`.
- Scripts resolve the workspace as the parent directory of this repository. Keep relative paths explicit and validate required modules/resources before destructive operations.
- The Maven Wrapper in this repository is the canonical wrapper for the workspace build. Run `mvnw.cmd -f pom.xml clean install` from this directory to build the reactor. The wrapper properties pin Maven; Java modules target Java 21.
- Build output and the assembled release directory are written to the workspace/module output paths, not committed here. Do not clean or overwrite existing user output without an explicit build action.

## Release assembly

- The assembler copies the built application JAR and distribution launch scripts from `hive-oss/src/distribution/` into `.release/build/` at the workspace level. It must not include secret configuration or publish anything to cloud storage.
- ZIP creation and publication are handled by the running Hive UI and `hive-release`; read `../hive-release/AGENTS.md` before changing that flow.
- Keep cross-module release pins in a reviewed release record when preparing a release. Do not treat whatever happens to be checked out locally as a reproducible release revision.
