
# NoSQL en PostgreSQL

Este documento explora cómo PostgreSQL, una base de datos relacional tradicional, ha incorporado capacidades NoSQL para manejar datos semiestructurados y no estructurados, ofreciendo flexibilidad sin sacrificar la robustez de las transacciones ACID.

---

## 🧩 ¿Qué es NoSQL en PostgreSQL?

Aunque PostgreSQL es una base de datos relacional, ofrece soporte para:

- **JSON / JSONB**: documentos semiestructurados.
- **HSTORE**: pares clave-valor.
- **Arrays**: listas de valores.
- **CTE recursivos**: para modelar grafos.

---

## 🔧 Ejemplo práctico

### 1. Crear tabla con JSONB
```sql
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);
```

### 2. Insertar datos
```sql
INSERT INTO usuarios (data)
VALUES 
  ('{"nombre": "Ana", "activo": true, "edad": 30}'),
  ('{"nombre": "Juan", "activo": false, "edad": 25}');
```

### 3. Consultar datos
```sql
SELECT data->>'nombre' AS nombre
FROM usuarios
WHERE data->>'activo' = 'true';
```

### 4. Índices GIN para JSONB
```sql
CREATE INDEX idx_data_gin ON usuarios USING GIN (data);
```
## 🧠 ¿Para qué sirve en JSONB?
Cuando tienes una columna JSONB con muchos datos semiestructurados, las consultas pueden volverse lentas si no hay un índice. El índice GIN permite:

Buscar claves y valores dentro del JSONB.
Usar operadores como @>, ?, ?&, ?| de forma eficiente.

Este índice permite acelerar consultas como:

```sql
SELECT * FROM usuarios
WHERE data @> '{"activo": true}';
```
Sin el índice GIN, PostgreSQL tendría que escanear toda la tabla. Con el índice, puede encontrar los registros mucho más rápido.
---

### 🧪 Pruebas unitarias
```sql
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 1 AND data->>'nombre' = 'Ana'
  ) THEN
    RAISE NOTICE 'OK: nombre correcto para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: nombre incorrecto para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 1 AND data->>'activo' = 'true'
  ) THEN
    RAISE NOTICE 'OK: usuario activo para id 1';
  ELSE
    RAISE EXCEPTION 'Fallo: usuario no está activo para id 1';
  END IF;

  IF EXISTS (
    SELECT 1 FROM usuarios WHERE id = 2 AND data->>'edad' = '25'
  ) THEN
    RAISE NOTICE 'OK: edad correcta para id 2';
  ELSE
    RAISE EXCEPTION 'Fallo: edad incorrecta para id 2';
  END IF;
END;
$$;
```
## 🧩 ¿Qué es HSTORE?
HSTORE es un tipo de dato en PostgreSQL que permite almacenar pares clave-valor en una sola columna. Es útil para datos semiestructurados, como configuraciones, atributos dinámicos o metadatos.

### 🔧 1. Activar la extensión HSTORE
Antes de usar HSTORE, debes habilitar la extensión:

```sql
CREATE EXTENSION IF NOT EXISTS hstore;
```

### 📦 2. Crear una tabla con columna HSTORE
```sql
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  atributos HSTORE
);
```

### 📝 3. Insertar datos en HSTORE
```sql
INSERT INTO productos (nombre, atributos)
VALUES 
  ('Laptop', 'marca => Dell, color => negro, ram => 16GB'),
  ('Teléfono', 'marca => Samsung, color => azul, ram => 8GB');
```

### 🔍 4. Consultar por clave específica
```sql
SELECT nombre
FROM productos
WHERE atributos -> 'color' = 'negro';
```

### 🔄 5. Actualizar un valor en HSTORE
```sql
UPDATE productos
SET atributos = atributos || 'ram => 32GB'
WHERE nombre = 'Laptop';
```

### 🧪 6. Eliminar una clave
```sql
UPDATE productos
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teléfono';
```

### 🧠 7. Extraer todas las claves y valores
```sql
SELECT skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos;
```

---

## 🧠 Ejercicios recomendados

1. Crear una tabla de productos con especificaciones en JSONB.    
2. Insertar al menos 5 productos con diferentes atributos.
3. Consultar productos por color, tamaño o categoría.
4. Crear índices GIN y medir el rendimiento.
5. Implementar pruebas unitarias.

 ## Ejercicios básicos de HSTORE

1. Crear una tabla con columna HSTORE     
  Define una tabla productos con atributos como marca, color, peso.
2. Insertar registros con múltiples pares clave-valor    
  Inserta al menos 5 productos con diferentes combinaciones de atributos.
3. Consultar por una clave específica     
  Encuentra todos los productos cuyo atributo color sea "rojo".
4. Actualizar un valor dentro del HSTORE     
  Cambia el valor de peso para un producto específico.
5. Eliminar una clave de un registro     
  Elimina el atributo color de un producto.

## 🔍 Ejercicios intermedios
1. Filtrar registros que contienen una clave     
  Usa el operador ? para encontrar productos que tengan el atributo marca.
2. Combinar HSTORE con otras columnas     
  Consulta productos que tengan marca = 'Sony' y precio > 500.
3. Extraer todas las claves y valores     
  Usa skeys() y svals() para listar todos los atributos de cada producto.
4. Contar cuántos productos tienen un atributo específico     
  ¿Cuántos productos tienen el atributo color?

## 🧠 Ejercicios avanzados
1. Indexar la columna HSTORE con GIN     
  Crea un índice para mejorar el rendimiento de búsquedas por clave.
2. Usar funciones agregadas con HSTORE     
  Agrupa productos por marca y cuenta cuántos hay por cada una.
3. Convertir HSTORE a JSON y viceversa     
  Practica con hstore_to_json() y json_to_hstore() si tienes datos mixtos.
4. Validar existencia de múltiples claves     
  Usa ?& para verificar si un producto tiene tanto color como peso.
9. Crear una función que reciba un HSTORE y devuelva un resumen    
  Por ejemplo, una función que devuelva "Producto X: marca=Y, color=Z".

---
