FROM public.ecr.aws/docker/library/debian:13-slim

RUN apt update \
 && apt install -y \
      bsdextrautils \
      build-essential \
      curl \
      file \
      gcc \
      git \
      htop \
      libc6 \
      libc6-dev \
      make \
      net-tools \
      openssl \
      procps \
      strace \
      telnet \
      tree \
      vim \
      wget \
  && apt clean -y

ENV BBSUID="9999" \
    BBSGID="999" \
    BBSUSER="bbs" \
    BBSGROUP="bbs" \
    BBSHOME="/home/bbs" \
    USRSHELL="/bin/bash"

RUN groupadd -g ${BBSGID} ${BBSGROUP} \
 && groupmod -g ${BBSGID} ${BBSGROUP} \
 && useradd -m -u ${BBSUID} -g ${BBSGROUP} -s /bin/bash -p $(tr -dc A-Za-z0-9 </dev/urandom | head -c 16; echo) ${BBSUSER}

ADD ./bbs ${BBSHOME}
RUN chown -R bbs:bbs ${BBSHOME}

USER bbs

WORKDIR ${BBSHOME}/src
RUN make clean linux install

WORKDIR ${BBSHOME}
USER root

RUN chown -R bbs:bbs ${BBSHOME}
