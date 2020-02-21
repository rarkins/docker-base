FROM amd64/ubuntu:18.04@sha256:0925d086715714114c1988f7c947db94064fd385e171a63c07730f1fa014e6f9

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8


RUN echo "APT::Install-Recommends \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf
RUN echo "APT::Get::Upgrade \"false\";" | tee -a /etc/apt/apt.conf.d/renovate.conf

RUN apt-get update && apt-get install -y \
    gpg \
    curl \
    ca-certificates \
    unzip \
    xz-utils \
    git \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*



# Set up ubuntu user and home directory with access to users in the root group (0)
# https://docs.openshift.com/container-platform/3.6/creating_images/guidelines.html#use-uid
ENV HOME=/home/ubuntu
RUN groupadd --gid 1000 ubuntu
RUN useradd --uid 1000 --gid ubuntu --groups 0 --shell /bin/bash --home-dir ${HOME} --create-home ubuntu

ENV APP_ROOT=/usr/src/app
WORKDIR ${APP_ROOT}
RUN chown -R ubuntu:0 ${APP_ROOT} ${HOME} && chmod -R g=u ${APP_ROOT} ${HOME}

USER 1000
