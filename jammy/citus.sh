#!/bin/bash

function package_version {
    apt show $1 2>/dev/null | grep "Version: " | awk -F' ' '{print $2}' | awk -F'+' '{print $1}' | awk -F'-' '{print $1}'
}


LIBC6_VER=$(package_version libc6)
export LIBC6_VER
LIBCURL4_VER=$(package_version libcurl4)
export LIBCURL4_VER
LIBLZ4_1_VER=$(package_version liblz4-1)
export LIBLZ4_1_VER
LIBPQ5_VER=$(package_version libpq5)
export LIBPQ5_VER
LIBSSL3_VER=$(package_version libssl3)
export LIBSSL3_VER
LIBZSTD1_VER=$(package_version libzstd1)
export LIBZSTD1_VER

git clone https://github.com/citusdata/citus.git
cd citus/
git checkout "v${CITUS_VERSION}"
basedir="$(pwd)"
rm -rf "${basedir}/.git"
pg_major="14"
builddir="${basedir}/build-${pg_major}"
mkdir -p "${builddir}" && cd "${builddir}"
CFLAGS=-Werror "${basedir}/configure" --enable-coverage --with-security-flags
installdir="${builddir}/install"
make && mkdir -p "${installdir}" && { make DESTDIR="${installdir}" install-all || make DESTDIR="${installdir}" install ; }
cd "${installdir}" && find . -type f -print > "${builddir}/files.lst"
mkdir -p "${OUTPUT_HOME}/${BUILD_ARCH}" && tar cvf "${OUTPUT_HOME}/install-${pg_major}-v${CITUS_VERSION}-${BUILD_ARCH}.tar" `cat ${builddir}/files.lst`
cd "${builddir}" && rm -rf install files.lst && make clean
pkgdir="${BUILD_HOME}/postgresql-${pg_major}-citus-${CITUS_VERSION}"
mkdir -p "$pkgdir/DEBIAN"
jinja2 "${BUILD_HOME}/control.tmpl" > "$pkgdir/DEBIAN/control"
tar -xvf "${OUTPUT_HOME}/install-${pg_major}-v${CITUS_VERSION}-${BUILD_ARCH}.tar" -C "$pkgdir"
cd "${BUILD_HOME}"
dpkg-deb --build --root-owner-group "postgresql-${pg_major}-citus-${CITUS_VERSION}"
cp "postgresql-${pg_major}-citus-${CITUS_VERSION}.deb" "${OUTPUT_HOME}/${BUILD_ARCH}"
