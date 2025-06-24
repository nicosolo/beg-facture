FROM oven/bun:1 AS base
WORKDIR /app

FROM base AS development
COPY . .
RUN bun install --network-concurrency=5

ENV NODE_ENV=development
EXPOSE 8080
CMD ["bun", "run", "dev"]

FROM base AS production
ENV NODE_ENV=production
COPY . .
RUN bun install --network-concurrency=5
WORKDIR /app/apps/app
CMD ["bun", "run", "build"]


