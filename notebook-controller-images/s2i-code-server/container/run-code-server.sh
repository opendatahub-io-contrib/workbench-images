#!/bin/bash

exec /usr/bin/code-server \
  --bind-addr 0.0.0.0:8888 \
  --disable-telemetry \
  --auth none \
  /opt/app-root/src