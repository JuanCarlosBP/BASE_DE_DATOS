SET SQL_SAFE_UPDATES = 0;

#1
INSERT INTO componente  (id_componente, id_mueble, nombre, descripcion, alto, ancho, fondo, peso) 
VALUES ('0', '3', 'Puerta', 'Puerta de madera DM lacada.', '650', '350', null, '1.500');

INSERT INTO componente  (id_componente, id_mueble, nombre, descripcion, alto, ancho, fondo, peso)
VALUES ('0', '5', 'Asiento', 'Asiento para silla tapizado en cuero', '70', '450', '500', null),
('0', '5', 'Respaldo', 'Respaldo para silla tapizado en cuero','56', '450', '750', '1.975');

#2
INSERT INTO componente (id_mueble, nombre, descripcion, alto, ancho, fondo, peso) 
SELECT (SELECT MAX(id_mueble) FROM mueble), nombre, descripcion, alto, ancho, fondo, peso FROM componente WHERE id_mueble ='2';

#3
UPDATE componente 
SET ancho=ancho * '2'
Where id_componente = last_insert_id()+1;

#4
UPDATE mueble SET descripcion = 'Recibidor con doble pueta', color = 'Turquesa', valoracion_clientes= '4'
where nombre= 'Palma';

#5
UPDATE mueble SET valoracion_clientes = (valoracion_clientes)+1
WHERE (id_mueble between '2' and '5') and (valoracion_clientes<'5');

#6
UPDATE componente SET peso = (peso /'2')
WHERE nombre='Pata';

#7
update componente 
inner join fabricado on fabricado.id_componente = componente.id_componente 
inner join fabricante on fabricante.nif = fabricado.nif_fabricante
set componente.descripcion = componente.nombre
where componente.id_componente in(select componente.id_componente where (componente.descripcion is null or '') and fabricante.localidad = 'Córdoba');

#8
Select componente.* from componente
inner join fabricado on fabricado.id_componente = componente.id_componente 
inner join fabricante on fabricante.nif = fabricado.nif_fabricante
where fabricante.razon_social = 'Componentes Garcia';

UPDATE fabricante SET nif = '12341234A'
WHERE razon_social='Componentes Garcia';

Select componente.*, fabricado.id_componente, fabricante.nif,fabricado.nif_fabricante   from componente
inner join fabricado on fabricado.id_componente = componente.id_componente 
inner join fabricante on fabricante.nif = fabricado.nif_fabricante
where fabricante.razon_social = 'Componentes Garcia';

#9
DELETE FROM fabricante
WHERE nif not IN (SELECT nif_fabricante FROM fabricado);

#10
DELETE FROM ubicacion
WHERE referencia IN (SELECT referencia_ubicacion FROM localizado
INNER JOIN localizado ON localizado.id_componente=componente.id_componente
WHERE componente.nombre='Pata');

#11
START TRANSACTION;
INSERT INTO mueble  (nombre, descripcion, color, valoracion_clientes, estado_catalogo) 
VALUES ('prueba1', 'Marco de puerta para sujección en pared', 'Blanco', 4, 'activo');
SAVEPOINT b_11;
INSERT INTO mueble  (nombre, descripcion, color, valoracion_clientes, estado_catalogo) 
VALUES ('prueba2', 'Marco de puerta para sujección en pared', 'Rojo', 3, 'activo');
ROLLBACK TO SAVEPOINT b_11;
COMMIT;

