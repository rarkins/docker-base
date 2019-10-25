FROM amd64/ubuntu:18.04@sha256:1bbdea4846231d91cce6c7ff3907d26fca444fd6b7e3c282b90c7fe4251f9f86

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y gpg curl unzip xz-utils git openssh-client && apt-get clean -y

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

WORKDIR /usr/src/app/
RUN chown -R ubuntu:ubuntu /usr/src/app

USER ubuntu
