SELECT nombre
FROM productos
WHERE atributos -> 'color' = 'negro';

UPDATE productos
SET atributos = atributos || 'ram => 32GB'
WHERE nombre = 'Laptop';

UPDATE productos
SET atributos = delete(atributos, 'color')
WHERE nombre = 'Teléfono';

SELECT skeys(atributos) AS clave, svals(atributos) AS valor
FROM productos;
