#!/bin/bash
set -e
cd "$(dirname "$0")"
# the_silver_searcher needs PCRE, liblzma (xz), and zlib. Homebrew's xz/pcre are
# keg-only, so add their include/lib paths and pkg-config dirs explicitly, else
# configure reports lzma.h missing and builds without xz search support.
XZ=$(brew --prefix xz); PCRE=$(brew --prefix pcre)
export PKG_CONFIG_PATH="$XZ/lib/pkgconfig:$PCRE/lib/pkgconfig:$PKG_CONFIG_PATH"
[ -f configure ] || ./autogen.sh
CPPFLAGS="-I$XZ/include -I$PCRE/include" LDFLAGS="-L$XZ/lib -L$PCRE/lib" \
    ./configure
make -j2
cp ag executable
