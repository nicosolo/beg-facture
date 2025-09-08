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

FROM base AS production
ENV NODE_ENV=production
COPY . .
RUN bun install --production --network-concurrency=5
# Ensure data directory exists
RUN mkdir -p /app/data

RUN cd apps/api && bun run build
EXPOSE 3000
VOLUME ["/app/data"]
CMD ["bun", "run", "start"]