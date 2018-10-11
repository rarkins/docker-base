FROM amd64/ubuntu:18.04@sha256:a819482773d99bbbb570626b6101fa37cd93a678581ee564e89feae903c95f20

RUN groupadd --gid 1000 ubuntu \
  && useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu
