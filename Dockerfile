FROM debian:stable-slim

# install packages required to run the tests
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
            wget \
            jq \
            coreutils \
            moreutils \
            ca-certificates \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN wget https://www.jsoftware.com/download/j901/install/j901_linux64.tar.gz \
      && tar -xvf j901_linux64.tar.gz \
      && mv j901 /opt/j901 \
      && apt-get -y --purge remove wget ca-certificates \
      && rm -rf j901_linux64.tar.gz

RUN /opt/j901/bin/jconsole -js \
      "load'pacman'" \
      "'update'jpkg''" \
      "'install'jpkg'convert/json'" \
      "'install'jpkg'general/unittest'" \
      "exit 0"

RUN mkdir /opt/test-runner
WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
