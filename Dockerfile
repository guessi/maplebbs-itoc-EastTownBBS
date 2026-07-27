FROM public.ecr.aws/docker/library/debian:13-slim AS base

# special notes for i386 system
# - https://www.debian.org/releases/stable/release-notes/issues.en.html#reduced-support-for-i386

ENV BBSUID="9999" \
    BBSGID="9999" \
    BBSUSER="bbs" \
    BBSGROUP="bbs" \
    BBSHOME="/home/bbs" \
    USRSHELL="/bin/bash"

RUN dpkg --add-architecture i386 \
 && groupadd -g ${BBSGID} ${BBSGROUP} \
 && useradd -m -u ${BBSUID} -g ${BBSGROUP} -s /bin/bash ${BBSUSER}

FROM base AS builder

RUN apt update \
 && apt install -y --no-install-recommends \
      gcc-multilib \
      libc6-dev:i386 \
      make \
 && apt clean -y \
 && rm -rf /var/lib/apt/lists/*

COPY --chown=bbs:bbs ./bbs ${BBSHOME}

USER bbs

WORKDIR ${BBSHOME}/src
RUN make clean linux install

FROM base

RUN apt update \
 && apt install -y --no-install-recommends \
      cron \
      libc6:i386 \
      libcrypt1:i386 \
 && apt clean -y \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder --chown=bbs:bbs ${BBSHOME} ${BBSHOME}

WORKDIR ${BBSHOME}

COPY docker-entrypoint.sh .
COPY crontab.bbs /etc/cron.d/bbs

# bhttpd (port 80) is disabled by default, see docker-entrypoint.sh
EXPOSE 23

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD bash -c '</dev/tcp/127.0.0.1/23' || exit 1

CMD ["./docker-entrypoint.sh"]
