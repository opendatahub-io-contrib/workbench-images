#!/bin/bash

# Cleanup Intel mess (not sure)
rm /opt/app-root/lib/libtbbbind_2_0.so.3 /opt/app-root/lib/libtbbbind_2_0.so
rm /opt/app-root/lib/libtbbbind_2_5.so.3 /opt/app-root/lib/libtbbbind_2_5.so
rm /opt/app-root/lib/libtbbbind.so.3 /opt/app-root/lib/libtbbbind.so
rm /opt/app-root/lib/libtbbmalloc_proxy.so.2 /opt/app-root/lib/libtbbmalloc_proxy.so
rm /opt/app-root/lib/libtbbmalloc.so.2 /opt/app-root/lib/libtbbmalloc.so
rm /opt/app-root/lib/libtbb.so.12 /opt/app-root/lib/libtbb.so

# Create proper Symlinks

find . -maxdepth 1 -name '*.so.*' -exec sh -c '
for so; do
  target="${so%.*}"
  while [ "${target##*.}" != "$target" ]; do
    ln -s "$so" "$target"
    target="${target%.*}"
  done
done' _ {} +