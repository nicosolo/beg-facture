# BEG Facture - Electron Desktop App

This is the Electron wrapper that packages BEG Facture as a desktop application.

## Development

### Prerequisites

- Docker and Docker Compose running (for the API and web app)
- Bun installed

### Running in Development

1. Start the Docker services (API and web app):

```bash
docker compose up --watch
```

2. Run the Electron app in development mode:

```bash
bun run electron:dev
```

The app will connect to the Docker services running on http://localhost:8084

## Building for Production

### Build the Electron app:

```bash
cd apps/electron
bun run dist
```

Set the `APP_URL` environment variable to point to your production web app:

```bash
APP_URL=https://app.beg-facture.com bun run dist:all
```

The packaged application will be in `apps/electron/dist/`
