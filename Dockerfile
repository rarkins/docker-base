FROM amd64/ubuntu:18.04@sha256:eb70667a801686f914408558660da753cde27192cd036148e58258819b927395

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y gpg curl unzip xz-utils git openssh-client && apt-get clean -y

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

USER ubuntu
