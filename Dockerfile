FROM maven:3.9.6

RUN apt-get -y update
RUN apt-get -y install git

ENTRYPOINT [ "/bin/sh" ]