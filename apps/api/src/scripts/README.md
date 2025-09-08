# MS Access Database Import Scripts

## Overview

These scripts allow you to import data from a Microsoft Access database (.mdb file) into the application's SQLite database.

## Usage

### Method 1: Command Line Script

Run the import script directly inside the container:

```bash
# Using environment variable
docker compose exec api sh -c "MS_ACCESS_DB_PATH=/path/to/database.mdb bun run db:import"

# Or passing the path as argument
docker compose exec api bun run db:import /path/to/database.mdb
```

### Method 2: API Endpoint

Make a POST request to the `/import` endpoint (requires admin authentication):

```bash
# First set the environment variable in your container
docker compose exec api sh -c "MS_ACCESS_DB_PATH=/path/to/database.mdb bun run start"

# Then call the API
curl -X POST http://localhost:4983/import \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

### Method 3: Legacy Import

To run the legacy import that expects JSON files in `/app/export-mdb`:

```bash
docker compose exec api bun run db:import-legacy
```

## Process

The import process consists of three steps:

1. **Export MDB to JSON**: Uses `mdb-tools` to extract tables from the Access database to JSON files in `/tmp`
2. **Import to SQLite**: Processes the JSON files and imports data into the SQLite database
3. **Cleanup**: Removes temporary JSON files

## Environment Variables

- `MS_ACCESS_DB_PATH`: Path to the Microsoft Access database file

## Requirements

- `mdb-tools` is installed in the container (already configured in Dockerfile)
- Admin privileges for API endpoint access
- Access to the .mdb file from within the container

## Notes

- The import process will reset the database before importing
- All temporary files are stored in `/tmp` and cleaned up after import
- The process handles data transformation and relationship mapping automatically