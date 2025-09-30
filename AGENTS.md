# Repository Guidelines

## Project Structure & Module Organization
- `apps/api` — Bun + Hono service; routes in `src/routes`, persistence in `src/db`, utilities in `src/scripts`.
- `apps/app/src` — Vue SPA with `components/{atoms,molecules,organisms,templates}`, composables, stores, and i18n.
- `apps/electron/src` — Electron shell for desktop builds.
- Shared assets: `packages/validations` for Zod schemas, `provision/nginx` for proxy config, data exports in `data/` and `export-mdb/`.

## Docker & Service Workflow
`compose.yml` runs the stack: API on port 4983, proxy at http://localhost:8084, Vite served through Nginx. Use `docker compose up --watch` for live sync, `docker compose logs -f [service]` to debug, and `docker compose down` to stop. Keep SQLite files in `data/db.sqlite` and `apps/api/data/db.sqlite` out of Git.

## Build, Test, and Development Commands
- `bun install` — install workspace dependencies.
- `docker compose exec api bun run dev` — restart the API watcher.
- `docker compose exec api bun run db:generate` / `db:migrate` / `db:seed` — manage Drizzle migrations.
- `docker compose exec api bun run db:import` — load Access exports.
- `docker compose exec app bun run build` — validate the production bundle.
- `cd apps/electron && bun run dev` or `bun run dist` — work on the desktop shell.
- `bun run docker:build` — bake multi-arch container images.

## Coding Style & Naming Conventions
TypeScript-first with ESLint + Prettier defaults (2-space indent, no semicolons). Name Vue components in `PascalCase.vue`; composables and stores stay `camelCase`. Keep Tailwind utilities in templates, group API code by domain (`src/routes/<area>`, `src/db/repositories/<area>`), and update shared contracts in `packages/validations`.

## Testing Guidelines
Run Docker services before hitting endpoints. Use `node test-unbilled.js` as the invoice aggregation smoke test on port 4983. Add Bun specs as `*.test.ts` beside the code and execute them with `docker compose exec <service> bun test`. Record fixture or import updates in `apps/api/src/scripts/README.md`.

## Commit & Pull Request Guidelines
Follow Conventional Commit prefixes (`feat:`, `fix:`, `chore:`) with imperative subjects and squash local fixups. PRs should outline scope, note deployment or migration impact, and add UI/Electron screenshots when relevant. Reference issues, list verification commands (`bun test`, targeted `docker compose exec` runs, `docker compose up --watch`), and mention new environment variables.

## Environment & Data Notes
Copy env templates referenced in `compose*.yml` and mention additions in the PR. Run Drizzle tooling inside the API container to keep paths consistent. Treat everything under `data/` and `export-mdb/` as generated artefacts—exclude them from commits.
