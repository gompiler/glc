FROM python:3.5-alpine3.9

RUN set -ex \
        && apk --update add --no-cache openjdk8-jre make curl ghc bash\
        && curl -sSL https://get.haskellstack.org/ | sh
# ENV PATH="${HOME}/.local/bin:${PATH}"
RUN mkdir -p /repo/
WORKDIR /repo/
ADD . /repo/
CMD ["./travis_test.sh"]
