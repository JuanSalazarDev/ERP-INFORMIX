#!/bin/bash

dbaccess <<!
create database control_erp
;
database control_erp
;
create table usuarios(
        id         serial not null primary key,
        usuario    char(38) not null,
	nombre     char(38),
	email      char(40),
	fecha_alta date
)
;
create index idx_1_usuarios on usuarios (usuario)
;
create table claves_usuarios(
	id_usuario decimal(8,0) not null primary key,
	salt       char(65),
	clave      char(65)
)
;
create table sesiones(
	id_usuario decimal(8,0) not null primary key,
	pid        decimal(14,0) not null,
	fecha      datetime year to second not null
)
;
create table programas_erp(
	id          decimal(8,0) not null primary key,
	descripcion char(40) not null,
	tipo        char(30) not null,
	fecha_alta  date not null
)
;
create table programas_usuarios(
	id_usuario       decimal(8,0) not null,
	id_programa      decimal(8,0) not null,
	fecha_asociacion date not null
)
;
create index idx_1_programas_usuarios on programas_usuarios (id_usuario, id_programa)
;
!

dbaccess <<!
database control_erp
;
insert into usuarios values (1, "admin", "", "", today)
;
insert into claves_usuarios values (1, "", "")
;
insert into programas_erp values (1, "Gestion usuarios", "4GI", today)
;
insert into programas_erp values (2, "Asociacion programas usuarios", "4GI", today)
;
insert into programas_usuarios values (1, 1, today)
;
insert into programas_usuarios values (1, 2, today)
;

!
