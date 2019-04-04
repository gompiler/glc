FROM debian:stable

RUN set -ex \
        && apt-get update\
        && apt-get install -y openjdk-8-jre python3.5 curl\
        && curl -sSL https://get.haskellstack.org/ | sh
RUN mkdir -p /repo/
WORKDIR /repo/
ADD . /repo/
RUN cd src && stack --no-terminal --install-ghc test --only-dependencies --pedantic
CMD ["./docker_test.sh"]
