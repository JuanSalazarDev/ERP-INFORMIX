#!/bin/bash

dbaccess <<!
database control_erp
;
drop table usuarios
;
drop table claves_usuarios
;
drop table sesiones
;
drop table programas_erp
;
drop table programas_usuarios
;
!

dbaccess <<!
drop database control_erp
;
!
