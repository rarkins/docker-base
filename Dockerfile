FROM amd64/ubuntu:18.04@sha256:3e83eca7870ee14a03b8026660e71ba761e6919b6982fb920d10254688a363d4

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y gpg curl unzip xz-utils git openssh-client && apt-get clean -y

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu

WORKDIR /usr/src/app/
RUN chown -R ubuntu:ubuntu /usr/src/app

USER ubuntu
