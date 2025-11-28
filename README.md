# BEG Management - Fullstack Project

A comprehensive invoicing and project management application with web, API, and desktop (Electron) clients.

## Quick Start

To install dependencies:

```bash
bun install
```

To run the development environment:

```bash
docker compose up --watch
```

This project was created using `bun init` in bun v1.1.36. [Bun](https://bun.sh) is a fast all-in-one JavaScript runtime.

#### Importing data dev

```bash
docker compose exec api bun src/scripts/import-mdb.ts
```

## Build docker images

#### On Apple Silicon (M1/M2) hosts (one time setup)

```bash
# Enable x86_64 emulation on ARM hosts (e.g., Apple Silicon)
docker run --privileged --rm tonistiigi/binfmt --install amd64
docker buildx create --name xbuilder --use
docker buildx inspect --bootstrap
```

#### Build images for multiple architectures (e.g., arm64 and amd64)

Using the automated script (recommended):

```bash
# Build and export all images in one command
bun run docker:build

# This will:
# 1. Build images using docker buildx bake
# 2. Export them to exports/ directory as tar files
```

## Sync images to server

After building with `bun run docker:build`, sync to server:

```bash
# Copy all exported tar files
scp -O exports/*.tar Nicolas@192.168.0.102:/volume1/docker/

# Copy compose file and environment
scp -O compose.prod.yml Nicolas@192.168.0.102:/volume1/docker/docker-compose.yml
scp -O .env.prod Nicolas@192.168.0.102:/volume1/docker/.env
```

#### Deploying to production server

First build with teh above command, then copy the tar files to your server and load them:

```bash
docker load -i beg-api.tar
docker load -i beg-proxy.tar
```

Then run the containers with docker-compose:

```bash
docker-compose -f docker-compose.yml up -d
```

## Reset all migrations

```bash
rm data/db.sqlite*
# remove the existing migrations folder
docker compose run --build api bunx drizzle-kit generate
docker compose run --build api bun run db:import
```
