#!/usr/bin/env bash

set -e

mkdir -p tiles-build/valhalla_tiles

CONTAINER_BUILD_DIR=/tiles-build

docker run --rm valhalla valhalla_build_config \
  --mjolnir-tile-dir $CONTAINER_BUILD_DIR/valhalla_tiles \
  --mjolnir-tile-extract $CONTAINER_BUILD_DIR/valhalla_tiles.tar \
  --mjolnir-timezone $CONTAINER_BUILD_DIR/valhalla_tiles/timezones.sqlite \
  --mjolnir-admin $CONTAINER_BUILD_DIR/valhalla_tiles/admins.sqlite \
  > tiles-build/valhalla.json
