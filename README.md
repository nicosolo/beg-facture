# fullstack-project

To install dependencies:

```bash
bun install
```

To run:

```bash
bun run index.ts
```

This project was created using `bun init` in bun v1.1.36. [Bun](https://bun.sh) is a fast all-in-one JavaScript runtime.

#### Importing data

```bash
sh export-mdb.sh /path/to/your/database.mdb
```

#### Exporting data

## Build docker images

#### On Apple Silicon (M1/M2) hosts (one time setup)

```bash
# Enable x86_64 emulation on ARM hosts (e.g., Apple Silicon)
docker run --privileged --rm tonistiigi/binfmt --install amd64
docker buildx create --name xbuilder --use
docker buildx inspect --bootstrap
```

#### Build images for multiple architectures (e.g., arm64 and amd64)

```bash
docker buildx bake --file compose.prod.yml --file docker-bake.json
```

# Export images to tar files

```bash
docker save beg/api:latest -o beg-api.tar
docker save beg/proxy:latest -o beg-proxy.tar
```

## Sync images to server

```bash
scp -O beg-api.tar Nicolas@192.168.0.102:/volume1/docker/api.tar
scp -O beg-proxy.tar Nicolas@192.168.0.102:/volume1/docker/proxy.tar
scp -O compose.prod.yml Nicolas@192.168.0.102:/volume1/docker/docker-compose.yml
scp -O .env.prod Nicolas@192.168.0.102:/volume1/docker/.env
```

#### Deploying to production server

First build with teh above command, then copy the tar files to your server and load them:

```bash
docker load -i api.tar
docker load -i proxy.tar
```

Then run the containers with docker-compose:

```bash
docker-compose -f compose.prod.yml up -d
```
