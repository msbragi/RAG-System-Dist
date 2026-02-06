#!/bin/bash
# -------------------------------------------------------------------------
# IMPORTANT!!!! if You changed users and passwords 
# for n8n and rag DBs synchronize it in the files
# 10-init-users-dbs
# 20-init-n8n-schema
# 30-init-rag-schema
# -------------------------------------------------------------------------

set -e

# Create DBs and users
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/10-init-users-dbs

# Init n8n_db
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "n8n_db" -f /docker-entrypoint-initdb.d/30-init-n8n-schema

# Init rag_db
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "rag_db" -f /docker-entrypoint-initdb.d/20-init-rag-schema
