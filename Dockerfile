FROM debian:stable-slim
RUN apt-get update && apt-get install -y wget
RUN wget https://www.jsoftware.com/download/j901/install/j901_linux64.tar.gz && \
      tar -xvf j901_linux64.tar.gz && \
      mv j901 /opt/j901
RUN /opt/j901/bin/jconsole -js \
      "load'pacman'" \
      "'update'jpkg''" \
      "'install'jpkg'convert/json'" \
      "'install'jpkg'general/unittest'" \
      "exit 0"

RUN mkdir /opt/test-runner
COPY . /opt/test-runner
WORKDIR /opt/test-runner
