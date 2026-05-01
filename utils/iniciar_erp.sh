#!/bin/bash

id_usuario=""

#
# ============================================================================================================
# Eliminar sesion del usuario
# ============================================================================================================
#
eliminar_sesion(){

dbaccess control_erp <<!
delete from sesiones
where id_usuario = "${id_usuario}"
!

}
#
# ============================================================================================================
# Eliminar sesiones que se encuentran activas
# ============================================================================================================
#
eliminar_sesiones_activas(){

read -s -p "DESEA ELIMINAR SESIONES ACTIVAS? s/n: " local eliminar

if ! echo "${eliminar}" | grep -qE "^[sSnN]$" ; then
	clear
	echo "OPCION INCORRECTA"
	return 1
fi

if echo "${eliminar}" | grep -qE "^[nN]$" ]]; then
	return 1
fi

eliminar_sesion

return 0

}
#
# ============================================================================================================
# Gestionar sesiones
# ============================================================================================================
#
gestionar_sesion(){

local archivo_sesiones=/tmp/sesiones_${$}_$(date '+%Y%m%d')

dbaccess control_erp <<!
unload to "${archivo_sesiones}" delimiter ";"
select count(*) from sesiones
where id_usuario = "${id_usuario}"
;
!

local numero_sesiones=$(cat ${archivo_sesiones} | cut -d ";" -f 1 | cut -d "." -f 1)

if [[ ${numero_sesiones} -ne 0 ]]; then
	if ! eliminar_sesiones_activas; then
		return 1
	fi
fi

dbaccess control_erp <<!
insert into sesiones values ("${id_usuario}", ${$}, current)
;
!

return 0

}
#
# ============================================================================================================
# Ejecutar login ERP
# ============================================================================================================
#
ejecutar_login(){

local archivo_usuario=/tmp/log_${$}_$(date '+%Y%m%d')

fglgo ./bin/login/login.4gi ${archivo_usuario}

if [[ $? -ne 0 ]]; then
	return 1
fi

id_usuario=$(cat ${archivo_usuario})
rm -rf ${archivo_usuario} 2> /dev/null

if [[ -z "${id_usuario}" ]]; then
	return 1
fi

return 0

}
#
# ============================================================================================================
# Inicio ejecucion script
# ============================================================================================================
#
if ! ejecutar_login; then
	exit 1
fi

if ! gestionar_sesion; then
	exit 1
fi

eliminar_sesion
