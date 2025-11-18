CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    atributos JSONB
);


CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);
