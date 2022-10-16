DROP DATABASE if exists muebles_bd03;
CREATE DATABASE muebles_bd03;
use muebles_bd03;
CREATE TABLE mueble(
id_mueble INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(250) NOT NULL UNIQUE,
descripción VARCHAR(250),
color VARCHAR(250),
valoración_clientes TINYINT UNSIGNED,
estado_catálogo ENUM ('activo', 'descatalogado', 'en-proyecto'),
constraint mue_val_CK CHECK (valoración_clientes BETWEEN 1 AND 5)
);
CREATE TABLE ubicación(
referencia INT PRIMARY KEY AUTO_INCREMENT,
sala varchar(250) NOT NULL UNIQUE,
pasillo INT NOT NULL,
estantería INT NOT NULL,
valda INT NOT NULL,
CONSTRAINT Ubi_UK UNIQUE (sala, pasillo, estantería, valda)
);
CREATE TABLE componente(
id_componente INT PRIMARY KEY AUTO_INCREMENT,
id_mueble INT NOT NULL,
nombre VARCHAR(250) NOT NULL,
descripción VARCHAR(250),
alto Float CHECK (alto > 0),
ancho Float CHECK (ancho > 0),
fondo Float CHECK (fondo > 0),
peso Float CHECK (peso > 0),
CONSTRAINT mue_id_m_FK FOREIGN KEY (id_mueble) REFERENCES mueble(id_mueble) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE fabricante(
nif INT PRIMARY KEY AUTO_INCREMENT,
razón_social VARCHAR(250) NOT NULL UNIQUE,
localidad VARCHAR(250) NOT NULL,
fecha_alta DATE NOT NULL DEFAULT (CURRENT_DATE),
nivel_fidelización TINYINT UNSIGNED CHECK (nivel_fidelización BETWEEN 1 AND 10)
);
CREATE TABLE fabricado(
id_componente INT,
nif_fabricante INT,
CONSTRAINT fdo_id_n_PK PRIMARY KEY (id_componente, nif_fabricante),
CONSTRAINT fte_nif_FK FOREIGN KEY (nif_fabricante) REFERENCES fabricante(nif) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT com_id_c_FK FOREIGN KEY (id_componente) REFERENCES componente(id_componente) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE localizado(
id_componente INT,
referencia_ubicación INT,
cantidad INT UNSIGNED,
CONSTRAINT loc_id_r_PK PRIMARY KEY (id_componente, referencia_ubicación),
CONSTRAINT ubi_ref_FK FOREIGN KEY (referencia_ubicación) REFERENCES ubicación(referencia) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT com_id_co_FK FOREIGN KEY (id_componente) REFERENCES componente(id_componente) ON DELETE CASCADE ON UPDATE CASCADE
);