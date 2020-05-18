
# renovate: datasource=docker depName=ubuntu versioning=docker
ARG UBUNTU_VERSION=18.10

#--------------------------------------
# base image
#--------------------------------------
FROM ubuntu:${UBUNTU_VERSION} as base

LABEL maintainer="Rhys Arkins <rhys@arkins.net>"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/docker-ubuntu"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8


RUN echo "APT::Install-Recommends \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf
RUN echo "APT::Get::Upgrade \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf
RUN echo "APT::Get::Install-Suggests \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf

RUN apt-get update && apt-get install -y \
    gnupg \
    curl \
    ca-certificates \
    unzip \
    xz-utils \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    . /etc/os-release; \
    echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/git.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
    apt-get update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*; \
    git --version

# Set up ubuntu user and home directory with access to users in the root group (0)
# https://docs.openshift.com/container-platform/3.6/creating_images/guidelines.html#use-uid
RUN groupadd --gid 1000 ubuntu
RUN useradd --uid 1000 --gid 0 --groups ubuntu --shell /bin/bash --create-home ubuntu

ENV APP_ROOT=/usr/src/app
WORKDIR ${APP_ROOT}
RUN chown ubuntu:0 ${APP_ROOT} && chmod g=u ${APP_ROOT}

LABEL org.opencontainers.image.version="${UBUNTU_VERSION}"


#--------------------------------------
# renovate rebuild trigger
#--------------------------------------
FROM amd64/ubuntu:18.04@sha256:b58746c8a89938b8c9f5b77de3b8cf1fe78210c696ab03a1442e235eea65d84f as trigger


#--------------------------------------
# final
#--------------------------------------
FROM base as final

USER 1000
