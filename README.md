# Valhalla docker

## North america example

Build docker image:
```
docker build . -t valhalla
```

Download the pbf file:

```
curl -O https://download.geofabrik.de/north-america-latest.osm.pbf
```

Create polylines:

```
./build-config.sh
./build-tiles.sh north-america-latest.osm.pbf
./export-edges.sh
```

Polylines can be found under `polylines/extract.0sv`
