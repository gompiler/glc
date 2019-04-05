FROM debian:stable

RUN set -ex \
        && apt-get update\
        && apt-get install -y openjdk-8-jre python3.5 curl\
        && curl -sSL https://get.haskellstack.org/ | sh\
        && stack setup
RUN mkdir -p /repo/
WORKDIR /repo/
COPY . /repo/
CMD ["./docker_test.sh"]
