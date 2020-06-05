#!/usr/bin/env bash

set -e

PBF_PATH=${1:?"Usage build-tiles.sh PBF_PATH e.g. ./build-tiles.sh north_america-latest.osm.pbf"}

CONTAINER_BUILD_DIR=/tiles-build

docker run --rm -d \
  --name valhalla-build-tiles \
  -w $CONTAINER_BUILD_DIR \
  -v "$PWD"/tiles-build:$CONTAINER_BUILD_DIR \
  --mount "type=bind,source=$PWD/$PBF_PATH,target=/pbf/osm.pbf" \
  valhalla valhalla_build_tiles -c valhalla.json /pbf/osm.pbf
