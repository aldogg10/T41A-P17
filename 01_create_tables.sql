CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  atributos HSTORE
);
