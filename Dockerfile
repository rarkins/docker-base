FROM amd64/ubuntu:18.04@sha256:2695d3e10e69cc500a16eae6d6629c803c43ab075fa5ce60813a0fc49c47e859

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN echo "APT::Install-Recommends \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf \
 && echo "APT::Get::Upgrade \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf

RUN apt-get update && apt-get install -y \
    gpg \
    curl \
    unzip \
    xz-utils \
    git \
    openssh-client \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 ubuntu \
 && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

WORKDIR /usr/src/app/
RUN chown -R ubuntu:ubuntu /usr/src/app

USER ubuntu
