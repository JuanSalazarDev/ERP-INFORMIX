#
# ============================================================================================================
# MODULO: menu.4gl
# EJECUTABLE: menu.4gi
# DESCRIPCION: Desplegar menu ERP
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
database control_erp
#
# ============================================================================================================
# Variables globales
# ============================================================================================================
#
globals

define
	mensaje_error char(2000),   # Mensaje de error generado
	nro_registros decimal(14,0) # Numero de registros totales consulta

end globals
#
# ============================================================================================================
# Variables modulo
# ============================================================================================================
#
define
	id_usuario             like usuarios.id, # Usuario
	reg_actual_cursor      decimal(14,0),    # Registro actual del cursor
	max_registros_pantalla integer,          # Maximo de registros que se renderizaran en pantalla

	programas_usuario array[10] of record
		indicador   char(1),                       # Indicador de campo actual
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

define
	usuario like usuarios.usuario, # Usuario
	ok           smallint          # Indicador estado transaccion

defer interrupt

let id_usuario = arg_val(1)

call obtener_usuario_t_usuarios(id_usuario) returning usuario, ok

call desplegar_cabecera_programa(usuario, "       M E N U      ")

error "Cargando programas . . ."

if cargar_menu(id_usuario) = false
	then
	error mensaje_error clipped
	exit program 1
end if

call desplegar_menu()

call cerrar_cursor_programas_usuario()

end main
#
# ============================================================================================================
# FUNCION: desplegar_menu()
# DESCRIPCION: Desplegar en pantalla menu del usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function desplegar_menu()

define
	anterior char(1),  # Control de registro anterior
	control char(1),   # Control de menu
	siguiente char(1), # Control de registro siguiente
	idx_arr smallint   # Indice record array

let idx_arr = 1
let reg_actual_cursor = 0

open window w_desplegar_menu at 3, 9 with form "./bin/menu/frm.d/menu" attribute(border, form line 1)

input anterior, control, siguiente without defaults from anterior, control, siguiente

	before field anterior
		if idx_arr != 1
			then
			let idx_arr = idx_arr - 1
		else
			call actualizar_array_menu(10, "A")
		end if
		next field control

	before field control
		call renderizar_menu(idx_arr)

	before field siguiente
		if idx_arr = 10
			then
			call actualizar_array_menu(8, "S")
		end if

		if idx_arr < max_registros_pantalla
			then
			let idx_arr = idx_arr + 1
		end if

		next field control

	on key (interrupt)
		let int_flag = false
		exit input

end input

close window w_desplegar_menu

end function
#
# ============================================================================================================
# FUNCION: actualizar_array_menu()
# DESCRIPCION: 
# AUTOR: Juan Salazar
# FECHA CREACION: 29/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function actualizar_array_menu(nro_registros_mov, ant_sig)

define
	ant_sig           char(1),  # Indicador de anterior o siguiente registro
	nro_registros_mov smallint, # Numero de registro reposicionar cursor
	idx               smallint, # Indice record array
	ok                smallint  # Indicador estado transaccion

if (reg_actual_cursor + 1) > nro_registros and ant_sig = "S"
	then
	return
end if

if (reg_actual_cursor - nro_registros_mov) <= 0
	then
	let reg_actual_cursor = 1
else
	let reg_actual_cursor = reg_actual_cursor - nro_registros_mov
end if

let max_registros_pantalla = 0

for idx = 1 to 10
	if idx = 1
		then
		call obtener_programa(reg_actual_cursor) 
			returning programas_usuario[idx].id, programas_usuario[idx].descripcion, ok
	else
		call obtener_programa(0)
			returning programas_usuario[idx].id, programas_usuario[idx].descripcion, ok
	end if

	if ok = false
		then
		exit for
	end if

	if idx < 10
		then
		let reg_actual_cursor = reg_actual_cursor + 1
	end if

	let max_registros_pantalla = max_registros_pantalla + 1
end for

end function
#
# ============================================================================================================
# FUNCION: renderizar_menu()
# DESCRIPCION: Renderizar en pantalla menu
# AUTOR: Juan Salazar
# FECHA CREACION: 29/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function renderizar_menu(idx_arr)

define
	idx_arr integer, # Indice actual record array
	idx integer      # Indice record array

for idx = 1 to max_registros_pantalla
	if idx = idx_arr
		then
		let programas_usuario[idx].indicador = ">"
		display programas_usuario[idx].* to programas_usuario[idx].* attribute(reverse)
		continue for
	end if

	initialize programas_usuario[idx].indicador to null
	display programas_usuario[idx].* to programas_usuario[idx].*
end for

end function
