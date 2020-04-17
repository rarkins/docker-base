
# renovate: datasource=docker depName=ubuntu versioning=docker
ARG UBUNTU_VERSION=18.04

FROM amd64/ubuntu:18.04@sha256:e5dd9dbb37df5b731a6688fa49f4003359f6f126958c9c928f937bec69836320 as bionic
FROM amd64/ubuntu:20.04@sha256:8e1c1ee12a539d652c371ee2f4ee66909f4f5fd8002936d8011d958f05faf989 as focal

FROM amd64/ubuntu:${UBUNTU_VERSION}

LABEL maintainer="Rhys Arkins <rhys@arkins.net>"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/docker-ubuntu"
LABEL org.opencontainers.image.version="${UBUNTU_VERSION}"

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

RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu bionic main\ndeb-src http://ppa.launchpad.net/git-core/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/git.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
    apt-get update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*

# Set up ubuntu user and home directory with access to users in the root group (0)
# https://docs.openshift.com/container-platform/3.6/creating_images/guidelines.html#use-uid
RUN groupadd --gid 1000 ubuntu
RUN useradd --uid 1000 --gid 0 --groups ubuntu --shell /bin/bash --create-home ubuntu

ENV APP_ROOT=/usr/src/app
WORKDIR ${APP_ROOT}
RUN chown ubuntu:0 ${APP_ROOT} && chmod g=u ${APP_ROOT}

USER 1000
