# Build the Citus 10.2 extension for Postgres on the arm64 Platform

## Requirements

+ buildah
+ podman
+ git
+ lsb-release
+ 64bit RPi

## Example

```bash
git clone git@github.com:shawnallen85/arm64builder-citus.git
arm64builder-citus/$(lsb_release -sc)/build-citus.sh
```
