#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ubuntu:bionic@sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98 as build-bionic
FROM ubuntu:focal@sha256:0b897358ff6624825fb50d20ffb605ab0eaea77ced0adb8c6a4b756513dec6fc as build-focal
FROM ghcr.io/containerbase/base:10.11.8@sha256:f5a6e43f69f66bfe29e0a55e10f7211676e5afd2948ab68943851cfca234d58d AS containerbase

#--------------------------------------
# builder images
#--------------------------------------
FROM build-${DISTRO} as builder

ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY --from=containerbase /usr/local/bin/ /usr/local/bin/
COPY --from=containerbase /usr/local/containerbase/ /usr/local/containerbase/
RUN install-containerbase

# renovate: datasource=github-tags lookupName=git/git
RUN install-tool git v2.45.2

COPY bin /usr/local/bin

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.22.4

RUN install-builder.sh

WORKDIR /src
