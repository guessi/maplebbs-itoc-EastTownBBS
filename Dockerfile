FROM public.ecr.aws/docker/library/debian:13-slim AS base

# special notes for i386 system
# - https://www.debian.org/releases/stable/release-notes/issues.en.html#reduced-support-for-i386

RUN dpkg --add-architecture i386 \
 && apt update \
 && apt install -y --no-install-recommends \
      cron \
      gcc-multilib \
      libc6-dev:i386 \
      make \
  && apt clean -y \
  && rm -rf /var/lib/apt/lists/*

ENV BBSUID="9999" \
    BBSGID="9999" \
    BBSUSER="bbs" \
    BBSGROUP="bbs" \
    BBSHOME="/home/bbs" \
    USRSHELL="/bin/bash"

RUN groupadd -g ${BBSGID} ${BBSGROUP} \
 && useradd -m -u ${BBSUID} -g ${BBSGROUP} -s /bin/bash ${BBSUSER}

FROM base

COPY --chown=bbs:bbs ./bbs ${BBSHOME}

USER bbs

WORKDIR ${BBSHOME}/src
RUN make clean linux install

WORKDIR ${BBSHOME}
USER root

COPY docker-entrypoint.sh .
COPY crontab.bbs /etc/cron.d/bbs

# bhttpd (port 80) is disabled by default, see docker-entrypoint.sh
EXPOSE 23

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD bash -c '</dev/tcp/127.0.0.1/23' || exit 1

CMD ["./docker-entrypoint.sh"]
