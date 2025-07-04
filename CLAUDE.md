# BEG Facture - Project Documentation

## Project Overview

BEG Facture is a fullstack invoicing application built with modern web technologies. The project uses a monorepo structure with separate applications for the API and web frontend.

## Tech Stack

- **Runtime**: Bun (v1.1.36+)
- **Backend**:
    - Hono (web framework)
    - Drizzle ORM with SQLite
    - JWT authentication
    - Zod validation
- **Frontend**:
    - Vue 3 with TypeScript
    - Vite as build tool
    - Vue Router for navigation
    - Pinia for state management
    - Tailwind CSS for styling
    - Vue I18n for internationalization
- **Database**: SQLite (migrated from MariaDB)
- **Development**: Docker Compose for containerized development

## Project Structure

```
.
├── apps/
│   ├── api/               # Backend API application
│   └── app/               # Frontend Vue application
├── packages/              # Shared packages
│   ├── types/            # Shared TypeScript types
│   ├── utils/            # Shared utilities
│   └── validations/      # Shared validation schemas
├── provision/
│   └── nginx/            # Nginx configuration
├── data/                 # Database files and legacy data
├── export-mdb/           # Exported data from legacy Access database
└── legacy/               # Legacy Delphi application files
```

## Development Setup

### Prerequisites

- Bun installed globally
- Docker and Docker Compose (for containerized development)

### Installation

```bash
# Install all dependencies
bun install
```

### Running the Application

```bash
# Development with Docker Compose (recommended)
bun run dev

# Or run individual apps:
# API
cd apps/api
bun run dev

# Frontend
cd apps/app
bun run dev
```

## API (Backend)

The API is built with Hono and provides RESTful endpoints for:

- User authentication and management
- Projects management
- Activities/time tracking
- Clients management
- Rates and invoicing
- Status tracking

### Key Scripts

- `bun run dev` - Start development server with hot reload
- `bun run db:generate` - Generate database migrations
- `bun run db:migrate` - Run database migrations
- `bun run db:seed` - Seed the database with initial data

### Authentication

The API uses JWT tokens for authentication with middleware to protect routes.

## Frontend Application

The frontend is a Vue 3 SPA with:

- Component-based architecture (atoms, molecules, organisms pattern)
- Composables for API interaction and utilities
- Type-safe API client
- Internationalization support (French)

### Key Scripts

- `bun run dev` - Start Vite dev server
- `bun run build` - Build for production
- `bun run preview` - Preview production build

### IDE Setup

Recommended: VSCode with Volar extension for Vue 3 support

## Database

The project recently migrated from MariaDB to SQLite. Database files are stored in:

- Development: `apps/api/data/db.sqlite`
- Root: `data/db.sqlite`

## Recent Changes

Based on recent commits:

- Migrated from MariaDB to SQLite
- Removed deprecated regions table
- Refactored API routes with improved response validation
- Enhanced authentication middleware
- Updated database import logic with proper password hashing
- Improved type safety and error management in API composables

## Docker Development

The project uses Docker Compose for development:

- `compose.yml` - Development configuration
- `compose.prod.yml` - Production configuration

Run with: `docker compose up --watch`

## Legacy System

The `legacy/` directory contains the original Delphi application (BEGfacture.dpr) that this system is replacing. The `export-mdb/` directory contains JSON exports from the legacy Access database.

## Important Notes

1. The project uses workspace dependencies managed by Bun
2. All packages use ES modules (`"type": "module"`)
3. The API includes a response validator tool for ensuring type safety
4. Database connections are configured for improved performance and concurrency
5. The frontend uses a structured component hierarchy for maintainability

## Contributing

When making changes:

1. Ensure TypeScript types are properly maintained
2. Run migrations when changing database schema
3. Update validation schemas in the shared validations package
4. Follow the existing component structure in the frontend
5. Maintain proper error handling and validation throughout

## Instructions

- Exclusively use english for all communication.
