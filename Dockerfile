FROM debian:stable-slim
RUN apt-get update && apt-get install -y wget
RUN wget http://www.jsoftware.com/download/j901/install/j901_linux64.tar.gz && \
      tar -xvf j901_linux64.tar.gz && \
      mv j901 /opt/j901
RUN /opt/j901/bin/jconsole -js "exit 0['install'jpkg'convert/json'['update'jpkg''[load 'pacman'"