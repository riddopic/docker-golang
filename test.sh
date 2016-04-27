#!/bin/bash
set -o errexit
set -o nounset

IMG="$REGISTRY/$REPOSITORY:$TAG"

echo "Checking image size"

MAX_SIZE=600000  # 600M
docker run --rm -it "$IMG" bash -c "[[ \"\$(du -d0 / 2>/dev/null | awk '{print \$1; print > \"/dev/stderr\"}')\" -lt \"$MAX_SIZE\" ]]"
docker run --rm -it "$IMG" bats /tmp/test/

echo "Test OK"
