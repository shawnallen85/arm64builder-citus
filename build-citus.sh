#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && (pwd -W 2> /dev/null || pwd))

while getopts c:a:v:h: flag
do
    case "${flag}" in
        c) CITUS_VERSION=${OPTARG};;
        a) BUILD_ARCH=${OPTARG};;
        v) TINI_VERSION=${OPTARG};;
        h) TINI_SHA=${OPTARG};;
    esac
done

buildah bud -t citus-10.2-pgsql-12-builder -f citus.Containerfile \
    --arch ${BUILD_ARCH:-arm64} \
    --build-arg BUILD_ARCH=${BUILD_ARCH:-arm64} \
    --build-arg TINI_VERSION=${TINI_VERSION:-0.19.0} \
    --build-arg TINI_SHA=${TINI_SHA:-eae1d3aa50c48fb23b8cbdf4e369d0910dfc538566bfd09df89a774aa84a48b9} \
    ${SCRIPT_DIR}

mkdir ~/citus-build

podman run --rm -v ~/citus-build:/var/output:z citus-10.2-pgsql-12-builder

ls -alh ~/citus-build
