#!/usr/bin/env bash

set -e

CONTAINER_BUILD_DIR=/tiles-build
POLYLINES_CONTAINER_DIR=/polylines


docker run -d --rm \
  --name valhalla-export-edges \
  -w $CONTAINER_BUILD_DIR \
  -v "$PWD/tiles-build:$CONTAINER_BUILD_DIR" \
  -v "$PWD/polylines:$POLYLINES_CONTAINER_DIR" \
  valhalla /bin/bash -c "valhalla_export_edges --config valhalla.json > $POLYLINES_CONTAINER_DIR/extract.0sv"
