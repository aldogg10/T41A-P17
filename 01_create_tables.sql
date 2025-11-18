CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  atributos HSTORE
);
