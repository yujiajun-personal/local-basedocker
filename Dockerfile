FROM amazonlinux:latest

RUN set -eux;

ENTRYPOINT ["tail", "-f", "/dev/null"]