#!/bin/bash
set -e

echo "======================================"
echo "Creating RAG database..."
echo "======================================"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ${RAG_DB_USER} WITH PASSWORD '${RAG_DB_PASSWORD}';
    CREATE DATABASE ${RAG_DB_NAME} OWNER ${RAG_DB_USER};
    
    \c ${RAG_DB_NAME}
    CREATE SCHEMA ${RAG_DB_SCHEMA} AUTHORIZATION ${RAG_DB_USER};
    GRANT ALL PRIVILEGES ON SCHEMA ${RAG_DB_SCHEMA} TO ${RAG_DB_USER};
    ALTER USER ${RAG_DB_USER} SET search_path TO ${RAG_DB_SCHEMA};
EOSQL

echo "======================================"
echo "Creating n8n database..."
echo "======================================"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ${DB_POSTGRESDB_USER} WITH PASSWORD '${DB_POSTGRESDB_PASSWORD}';
    CREATE DATABASE ${DB_POSTGRESDB_DATABASE} OWNER ${DB_POSTGRESDB_USER};
    
    \c ${DB_POSTGRESDB_DATABASE}
    CREATE SCHEMA ${DB_POSTGRESDB_SCHEMA} AUTHORIZATION ${DB_POSTGRESDB_USER};
    GRANT ALL PRIVILEGES ON SCHEMA ${DB_POSTGRESDB_SCHEMA} TO ${DB_POSTGRESDB_USER};
    ALTER USER ${DB_POSTGRESDB_USER} SET search_path TO ${DB_POSTGRESDB_SCHEMA};
EOSQL

echo "======================================"
echo "Initializing RAG schema..."
echo "======================================"

psql -v ON_ERROR_STOP=1 --username "${RAG_DB_USER}" --dbname "${RAG_DB_NAME}" \
     -f /docker-entrypoint-initdb.d/30-init-rag-schema

echo "======================================"
echo "Database initialization completed!"
echo "======================================"