ARG UBUNTU_VERSION=bionic
ARG BASE_IMAGE=ubuntu:${UBUNTU_VERSION}
ARG USER_NAME=ubuntu
ARG USER_ID=1000

#--------------------------------------
# base image
#--------------------------------------
FROM ${BASE_IMAGE} as base

ARG USER_NAME
ARG USER_ID

LABEL maintainer="Rhys Arkins <rhys@arkins.net>"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/docker-ubuntu"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8


RUN echo "APT::Install-Recommends \"false\";" | tee -a /etc/apt/apt.conf.d/buildpack.conf
RUN echo "APT::Get::Upgrade \"false\";" | tee -a /etc/apt/apt.conf.d/buildpack.conf
RUN echo "APT::Get::Install-Suggests \"false\";" | tee -a /etc/apt/apt.conf.d/buildpack.conf

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

# Set up user and home directory with access to users in the root group (0)
# https://docs.openshift.com/container-platform/3.6/creating_images/guidelines.html#use-uid
RUN groupadd --gid ${USER_ID} ${USER_NAME}
RUN useradd --uid ${USER_ID} --gid 0 --groups ${USER_NAME} --shell /bin/bash --create-home ${USER_NAME}

ENV APP_ROOT=/usr/src/app
WORKDIR ${APP_ROOT}
RUN chown ${USER_NAME}:0 ${APP_ROOT} && chmod g=u ${APP_ROOT}

#--------------------------------------
# renovate rebuild trigger
#--------------------------------------
FROM amd64/ubuntu:bionic@sha256:2aeed98f2fa91c365730dc5d70d18e95e8d53ad4f1bbf4269c3bb625060383f0 as trigger


#--------------------------------------
# final
#--------------------------------------
FROM base as final

ARG USER_ID

USER ${USER_ID}
