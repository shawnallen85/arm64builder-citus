FROM ubuntu:jammy
LABEL maintainer="shawn@castleblack.us"
LABEL version="citus-10.2-pgsql-14-builder"
LABEL description="Container image for building the Citus extension for Postgres 14 on the arm64 architecture"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ENV CITUS_VERSION="10.2.5"
ENV BUILD_HOME="/var/citus"
ENV OUTPUT_HOME="/var/output"
ARG BUILD_ARCH
ENV BUILD_ARCH ${BUILD_ARCH:-arm64}
RUN apt update && \
	apt full-upgrade -y && \
	apt install -y \
		flex \
		bison \
		build-essential \
		autoconf \
		postgresql-server-dev-14 \
		libssl-dev \
		libcurl4-openssl-dev \
		liblz4-dev \
		libzstd-dev \
		libkrb5-dev \
		libicu-dev \
		git \
		debhelper \
		dh-make \
		python3-pip \
		curl \
		tini && \
	pip3 install jinja2-cli && \
	rm -rf /var/lib/apt/lists/* && \
	apt clean
WORKDIR /var/citus
COPY citus.sh /usr/local/bin/citus.sh
COPY control.tmpl /var/citus/control.tmpl
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/citus.sh"]
