FROM public.ecr.aws/docker/library/debian:13-slim AS base

# special notes for i386 system
# - https://www.debian.org/releases/stable/release-notes/issues.en.html#reduced-support-for-i386

RUN dpkg --add-architecture i386 \
 && apt update \
 && apt install -y --no-install-recommends \
      gcc-multilib \
      libc6-dev:i386 \
      make \
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

FROM base

ADD --chown=bbs:bbs ./bbs ${BBSHOME}

USER bbs

WORKDIR ${BBSHOME}/src
RUN make linux install clean

WORKDIR ${BBSHOME}
USER root

RUN chown -R bbs:bbs ${BBSHOME}

ADD docker-entrypoint.sh .

CMD ["./docker-entrypoint.sh"]
