# hive-build

Cross-module build and release-assembly tooling for the local Hive workspace. `hive/` itself is intentionally not a Git repository; this directory is an independent Git repository alongside the module repositories.

## Workspace layout

The scripts expect `hive-build/` next to the independent checkouts of `external-bom/`, `hive-domain/`, `hive-encryption/`, `db2oss/`, `hive-oss-frontend/`, `hive-release/`, and `hive-oss/`.

## Build

From the workspace directory, build all modules with one Maven command:

```cmd
hive-build\mvnw.cmd -f hive-build\pom.xml clean install
```

The reactor POM aggregates the sibling repositories. Maven orders projects from their parent and dependency relationships; `db2oss` and `hive-encryption` recursively include their child modules.

To build and then assemble the release directory, run:

```cmd
hive-build\package-release.cmd
```

The script invokes the reactor once with tests skipped, then runs the assembler. The application JAR is written to `../hive-oss/target/`; assembly copies it and the distribution launch scripts to `../.release/build/`. Deployment ZIP creation and publication remain in the Hive UI workflow.

`assemble-release.cmd` can be run separately after the application JAR has been built. It replaces the generated `.release/build/` output directory when explicitly run.

## Release reproducibility

The workspace build uses the currently checked-out module sources and does not validate the release manifest template. Before a real release, record the exact module tags or commit IDs used and ensure intended changes are committed. A local workspace checkout alone is not a release lockfile.
