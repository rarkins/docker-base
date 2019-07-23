FROM amd64/ubuntu:18.04@sha256:d91842ef309155b85a9e5c59566719308fab816b40d376809c39cf1cf4de3c6a

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y gpg curl unzip xz-utils git openssh-client && apt-get clean -y

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

USER ubuntu
