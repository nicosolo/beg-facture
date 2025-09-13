FROM oven/bun:1 AS base
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

COPY . .
EXPOSE 3000
VOLUME ["/app/data", "/app/apps/api/drizzle"]
CMD ["bun", "run", "dev"]

FROM debian:bookworm-slim AS production
WORKDIR /app

# Install dependencies and Bun x64-baseline version
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    mdbtools \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen C.UTF-8 \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=C.UTF-8

# Download and install Bun x64-baseline version
RUN curl -fsSL https://github.com/oven-sh/bun/releases/download/bun-v1.2.2/bun-linux-x64-baseline.zip -o bun.zip \
    && unzip bun.zip \
    && mv bun-linux-x64-baseline/bun /usr/local/bin/bun \
    && chmod +x /usr/local/bin/bun \
    && rm -rf bun.zip bun-linux-x64-baseline

# Set locale environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV NODE_ENV=production

COPY . .
RUN bun install --production --network-concurrency=5
# Ensure data directory exists
RUN mkdir -p /app/data

EXPOSE 3000
VOLUME ["/app/data"]
CMD ["bun", "run", "start"]