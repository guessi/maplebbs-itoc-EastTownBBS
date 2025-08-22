#!/usr/bin/env bash

echo "[debug] starting bbsd ..."
/home/bbs/bin/bbsd

echo "[debug] starting bmtad ..."
/home/bbs/bin/bmtad

echo "[debug] starting gemd ..."
/home/bbs/bin/gemd

echo "[debug] starting bhttpd ..."
/home/bbs/bin/bhttpd

echo "[debug] starting bguard ..."
/home/bbs/bin/bguard

echo "[debug] starting bpop3d ..."
/home/bbs/bin/bpop3d

echo "[debug] starting bnntpd ..."
/home/bbs/bin/bnntpd

echo "[debug] starting xchatd ..."
/home/bbs/bin/xchatd

echo "[debug] starting innbbsd ..."
/home/bbs/innd/innbbsd

echo "[debug] starting camera ..."
su bbs -c '/home/bbs/bin/camera'

echo "[debug] starting account ..."
su bbs -c '/home/bbs/bin/account'

echo "[debug] sleep infinity to keep docker running"
sleep infinity
