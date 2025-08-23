FROM public.ecr.aws/docker/library/debian:13-slim AS base

RUN apt update \
 && apt install -y --no-install-recommends \
      gcc \
      libc6-dev \
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
