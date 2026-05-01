#
# ============================================================================================================
# MODULO: programas_usuario.4gl
# EJECUTABLE:
# DESCRIPCION: Servicios relacionados al procesamiento de programas de usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 01/05/2026
# ============================================================================================================
#
database control_erp

globals

define
	mensaje_error char(2000),   # Mensaje de error generado
	nro_registros decimal(14,0) # Numero de registros totales consulta

end globals
#
# ============================================================================================================
# FUNCION: crear_cursor_programas_usuario()
# OBJETIVO: Crear cursor de programas asociados a usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 29/04/2026
# ============================================================================================================
#
function crear_cursor_programas_usuario()

define
	sentencia_sql char(4800) # Sentencia SQL

let sentencia_sql =
	"select p.id, p.descripcion from programas_erp p, programas_usuarios pu ",
	"where p.id = pu.id_programa ",
	"and pu.id_usuario = ? ",
	"order by p.id "
prepare p_programas_usuario from sentencia_sql
declare c_programas_usuario scroll cursor with hold for p_programas_usuario
free p_programas_usuario

end function
#
# ============================================================================================================
# FUNCION: cargar_menu()
# DESCRIPCION: Cargar listado de programas del usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 29/Abr/2026
# FECHA ULTIMA MODIFICACION: 29/Abr/2026
# ============================================================================================================
#
function cargar_menu(id_usuario)

define
	id_usuario like usuarios.id # ID usuario

if existen_programas_para_usuario(id_usuario) = false
	then
	return false
end if

call crear_cursor_programas_usuario()

open c_programas_usuario using id_usuario

return true

end function
#
# ============================================================================================================
# FUNCION: existen_programas_para_usuario()
# DESCRIPCION: Verificar si el usuario tiene programas asociados
# AUTOR: Juan Salazar
# FECHA CREACION: 29/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function existen_programas_para_usuario(id_usuario)

define
	id_usuario like usuarios.id # ID usuario

initialize nro_registros to null

select count(*) into nro_registros from programas_usuarios
where id_usuario = id_usuario

if nro_registros is null or nro_registros = 0
	then
	let mensaje_error = "No existen programas asociados al usuario, contacte al administrador"
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: obtener_programas()
# OBJETIVO: Obtener programas asociados a usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 29/04/2026
# ============================================================================================================
#
function obtener_programa(nro_registro_mov)

define
	nro_registro_mov integer,                         # Numero de registro reposicionar cursor
	id_programa       like programas_erp.id,          # ID programa
	descripcion_prg   like programas_erp.descripcion, # Descripcion programa
	ok                smallint                        # Indicador estado transaccion

initialize id_programa, descripcion_prg, ok to null

let ok = true

if nro_registro_mov != 0
	then
	fetch absolute nro_registro_mov c_programas_usuario into id_programa, descripcion_prg
else
	fetch next c_programas_usuario into id_programa, descripcion_prg
end if

if sqlca.sqlcode != 0
	then
	let ok = false
end if

return id_programa, descripcion_prg, ok

end function
#
# ============================================================================================================
# FUNCION: cerrar_cursor_programas_usuario()
# OBJETIVO: Cerrar cursor de programas asociados a usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 27/04/2026
# FECHA ULTIMA MODIFICACION: 27/04/2026
# ============================================================================================================
#
function cerrar_cursor_programas_usuario()

close c_programas_usuario
free c_programas_usuario

end function
