FROM amd64/ubuntu:18.04@sha256:cef0c2cde57a973ed80513a7d3614bc654d9d6becad2c068c9328b41bb3f6713

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y gpg curl unzip xz-utils git openssh-client && apt-get clean -y

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

USER ubuntu
