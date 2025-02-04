FROM oven/bun:1 as base
WORKDIR /app

FROM base as development
COPY . .
RUN bun install


ENV NODE_ENV=development
EXPOSE 8080
CMD ["bun", "run", "dev"]

FROM base as production
ENV NODE_ENV=production
COPY . .
RUN bun install --production

RUN cd apps/app && bun run build


