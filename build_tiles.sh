mkdir -p tiles-build/valhalla_tiles

CONTAINER_BUILD_DIR=/tiles-build

docker run valhalla valhalla_build_config --mjolnir-tile-dir ${CONTAINER_BUILD_DIR}/valhalla_tiles --mjolnir-tile-extract ${CONTAINER_BUILD_DIR}/valhalla_tiles.tar --mjolnir-timezone ${CONTAINER_BUILD_DIR}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${CONTAINER_BUILD_DIR}/valhalla_tiles/admins.sqlite > tiles-build/valhalla.json

docker run -w ${CONTAINER_BUILD_DIR} -v ${PWD}/tiles-build:${CONTAINER_BUILD_DIR} -v ${PWD}/pbf:/pbf valhalla valhalla_build_tiles -c valhalla.json /pbf/north-america-latest.osm.pbf
