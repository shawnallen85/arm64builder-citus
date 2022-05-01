FROM ubuntu:focal
LABEL maintainer="shawn@castleblack.us"
LABEL version="citus-10.2-pgsql-12-builder"
LABEL description="Container image for building the Citus extension for Postgres 12 on the arm64 architecture"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ENV CITUS_VERSION="10.2.5"
ENV BUILD_HOME="/var/citus"
ENV OUTPUT_HOME="/var/output"
ARG BUILD_ARCH
ENV BUILD_ARCH ${BUILD_ARCH:-arm64}
ENV TINY_ARCH ${BUILD_ARCH:-arm64}
ARG TINI_VERSION
ENV TINI_VERSION ${TINI_VERSION:-0.19.0}
ARG TINI_SHA
ENV TINI_SHA ${TINI_SHA:-eae1d3aa50c48fb23b8cbdf4e369d0910dfc538566bfd09df89a774aa84a48b9}
RUN apt update && \
	apt full-upgrade -y && \
	apt install -y \
		flex \
		bison \
		build-essential \
		autoconf \
		postgresql-server-dev-12 \
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
		curl && \
	pip3 install jinja2-cli && \
	rm -rf /var/lib/apt/lists/* && \
	apt clean && \
	curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-${TINY_ARCH} -o /bin/tini && \
	chmod +x /bin/tini && \
	echo "$TINI_SHA /bin/tini" | sha256sum -c -
WORKDIR /var/citus
COPY citus.sh /usr/local/bin/citus.sh
COPY control.tmpl /var/citus/control.tmpl
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/citus.sh"]
