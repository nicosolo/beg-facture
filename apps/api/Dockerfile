FROM oven/bun:1.2.2 AS base
WORKDIR /app
# Install mdb-tools for Access database support and locale support
RUN apt-get update && apt-get install -y \
    mdbtools \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen C.UTF-8 \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=C.UTF-8

# Set locale environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

FROM base AS development
ENV NODE_ENV=development
COPY . .
RUN bun install --network-concurrency=5
# Ensure data directory exists
RUN mkdir -p /app/data

VOLUME ["/app/data", "/app/apps/api/drizzle"]
CMD ["bun", "run", "dev"]


FROM base AS bun-dependencies

# install with --production (exclude devDependencies)
RUN mkdir -p /temp/prod

WORKDIR /temp/prod
COPY package.json bun.lockb ./
RUN ls -la
COPY apps/api/package.json ./apps/api/
COPY apps/app/package.json ./apps/app/
COPY packages/validations/package.json ./packages/validations/
RUN bun install --frozen-lockfile --network-concurrency=5 --production

# Separate stage for downloading Bun to avoid keeping curl/unzip in final image
FROM debian:bookworm-slim AS bun-installer
RUN apt-get update && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://github.com/oven-sh/bun/releases/download/bun-v1.2.2/bun-linux-x64-baseline.zip -o bun.zip \
    && unzip bun.zip \
    && mv bun-linux-x64-baseline/bun /usr/local/bin/bun \
    && chmod +x /usr/local/bin/bun \
    && rm -rf bun.zip bun-linux-x64-baseline

FROM debian:bookworm-slim AS production
WORKDIR /app

# Install runtime dependencies only (no curl/unzip needed)
RUN apt-get update && apt-get install -y \
    mdbtools \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen C.UTF-8 \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=C.UTF-8

# Copy Bun binary from installer stage
COPY --from=bun-installer /usr/local/bin/bun /usr/local/bin/bun
COPY --from=bun-dependencies /temp/prod/node_modules ./node_modules
# Set locale environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV NODE_ENV=production

# Copy the rest of the application
COPY . .

# Ensure data directory exists
RUN mkdir -p /app/data

EXPOSE 3000
VOLUME ["/app/data"]
CMD ["bun", "run", "start"]