FROM oven/bun:1 AS base
WORKDIR /app

FROM base AS development
ENV NODE_ENV=development
COPY . .
RUN bun install --network-concurrency=5

COPY . .
EXPOSE 3000
CMD ["bun", "run", "dev"]

FROM base AS production
ENV NODE_ENV=production
COPY . .
RUN bun install --production --network-concurrency=5

RUN cd apps/api && bun run build
EXPOSE 3000
CMD ["bun", "run", "start"]