#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

while getopts c:a:v:h: flag
do
    case "${flag}" in
        c) CITUS_VERSION=${OPTARG};;
        a) BUILD_ARCH=${OPTARG};;
    esac
done

buildah bud -t citus-10.2-pgsql-14-builder -f citus.Containerfile \
    --arch ${BUILD_ARCH:-arm64} \
    --build-arg BUILD_ARCH=${BUILD_ARCH:-arm64} \
    ${SCRIPT_DIR}

mkdir -p ~/citus-build/14

podman run --rm -v ~/citus-build/14:/var/output:z citus-10.2-pgsql-14-builder

ls -alh ~/citus-build/14
