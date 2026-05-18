FROM debian:trixie-slim@sha256:109e2c65005bf160609e4ba6acf7783752f8502ad218e298253428690b9eaa4b AS build
ARG VERSION=j9.5

ADD https://www.jsoftware.com/download/${VERSION}/install/${VERSION}_linux64.tar.gz /opt/${VERSION}_linux64.tar.gz
WORKDIR /opt
RUN apt-get update && apt-get install --yes --no-install-recommends patchelf 
RUN tar -xvf ${VERSION}_linux64.tar.gz && \
    patchelf --clear-execstack /opt/${VERSION}/bin/libj.so && \
    /opt/${VERSION}/bin/jconsole -js "load'pacman'" "'update'jpkg''" "'install'jpkg'convert/json'" "'install'jpkg'general/unittest'" "exit 0"

FROM debian:trixie-slim@sha256:109e2c65005bf160609e4ba6acf7783752f8502ad218e298253428690b9eaa4b
ARG VERSION=j9.5

RUN apt-get update && apt-get install --yes --no-install-recommends jq && rm -r /var/lib/apt/lists/*

WORKDIR /opt/test-runner

COPY --from=build /opt/${VERSION} /opt/${VERSION}
COPY . .

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
