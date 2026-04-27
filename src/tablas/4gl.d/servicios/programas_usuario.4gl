#
# ============================================================================================================
# MODULO: programas_usuario.4gl
# EJECUTABLE:
# DESCRIPCION: Servicios relacionados al procesamiento de programas de usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 27/04/2026
# ============================================================================================================
#
database control_erp

define
	cursor_programas_usuario_creado smallint # Indicador de que el cursor 1 ya fue creado
#
# ============================================================================================================
# FUNCION: crear_cursor_programas_usuario()
# OBJETIVO: Crear cursor de programas asociados a usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 27/04/2026
# ============================================================================================================
#
function crear_cursor_programas_usuario()

define
	sentencia_sql char(4800) # Sentencia SQL

let sentencia_sql =
	"select p.id, p.descripcion from programas_erp p, programas_usuarios pu ",
	"where p.id = pu.id_programa ",
	"and pu.id_usuario = ? "
prepare p_programas_usuario from sentencia_sql
declare c_programas_usuario cursor with hold for p_programas_usuario
free p_programas_usuario

let cursor_programas_usuario_creado = true

end function
#
# ============================================================================================================
# FUNCION: obtener_programas()
# OBJETIVO: Obtener programas asociados a usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 25/04/2026
# FECHA ULTIMA MODIFICACION: 27/04/2026
# ============================================================================================================
#
function obtener_programa(id_usuario)

define
	id_usuario      like usuarios.id,               # ID usuario
	id_programa     like programas_erp.id,          # ID programa
	descripcion_prg like programas_erp.descripcion, # Descripcion programa
	ok              smallint                        # Indicador estado transaccion

initialize id_programa, descripcion_prg, ok to null

let ok = true

if cursor_programas_usuario_creado = false
	then
	call crear_cursor_programas_usuario()

	open c_programas_usuario using id_usuario
end if

fetch c_programas_usuario into id_programa, descripcion_prg

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
