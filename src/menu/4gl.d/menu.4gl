#
# ============================================================================================================
# MODULO: menu.4gl
# EJECUTABLE: menu.4gi
# DESCRIPCION: Desplegar menu ERP
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 27/Abr/2026
# ============================================================================================================
#
database control_erp

define
	id_usuario    like usuarios.id, # Usuario
	MAX_REGISTROS integer,          # Maxima cantidad registros record array
	mensaje_error char(2000),       # Mensaje de error generado

	programas_usuario array[100] of record
		id          like programas_erp.id,         # ID programa
		descripcion like programas_erp.descripcion # Descripcion programa
	end record
#
# ============================================================================================================
# FUNCION: main()
# DESCRIPCION: Inicio ejecucion aplicacion
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 25/Abr/2026
# ============================================================================================================
#
main

defer interrupt

let id_usuario = arg_val(1)
let MAX_REGISTROS = 100

error "Cargando programas . . ."

if cargar_menu() = false
	then
	error mensaje_error clipped
	exit program 1
end if

call desplegar_menu()

end main
#
# ============================================================================================================
# FUNCION: cargar_menu()
# DESCRIPCION: Cargar menu del usuario con listado de programas del usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/Abr/2026
# FECHA ULTIMA MODIFICACION: 27/Abr/2026
# ============================================================================================================
#
function cargar_menu()

define
	idx integer, # Indice record array
	ok  smallint # Indicador estado transaccion

for idx = 1 to MAX_REGISTROS
	call obtener_programa(id_usuario) returning programas_usuario[idx].*, ok

	if ok = false
		then
		exit for
	end if
end for

call cerrar_cursor_programas_usuario()

if idx = 1
	then
	let mensaje_error = "No tiene programas asignados, contacte al administrador"
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: desplegar_menu()
# DESCRIPCION: Desplegar en pantalla menu del usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/Abr/2026
# FECHA ULTIMA MODIFICACION: 25/Abr/2026
# ============================================================================================================
#
function desplegar_menu()

end function
