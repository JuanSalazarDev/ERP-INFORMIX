#
# ============================================================================================================
# MODULO: programas_erp.4gl
# EJECUTABLE:
# DESCRIPCION: Rutinas de acceso, insercion, actualizacion, eliminacion en tabla "programas_erp"
# AUTOR: Juan Salazar
# FECHA CREACION: 01/May/2026
# FECHA ULTIMA MODIFICACION: 02/May/2026
# ============================================================================================================
#
database control_erp
#
# ============================================================================================================
# FUNCION: obtener_programa_t_programas_erp()
# OBJETIVO: Obtener programa de tabla "programas_erp"
# AUTOR: Juan Salazar
# FECHA CREACION: 01/May/2026
# FECHA ULTIMA MODIFICACION: 02/May/2026
# ============================================================================================================
#
function obtener_programa_t_programas_erp(id_programa)

define
	id_programa   like programas_erp.id,       # Usuario
	programa      like programas_erp.programa, # ID usuario
	sentencia_sql char(4800),                  # Sentencia SQL
	ok            smallint                     # Indicador estado transaccion

initialize programa, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select programa from programas_erp ",
	"where id = ? "
prepare p_obtener_programa_t_programas_erp from sentencia_sql
declare c_obtener_programa_t_programas_erp cursor with hold for p_obtener_programa_t_programas_erp
free p_obtener_programa_t_programas_erp

open c_obtener_programa_t_programas_erp using id_programa
fetch c_obtener_programa_t_programas_erp into programa

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close c_obtener_programa_t_programas_erp
free c_obtener_programa_t_programas_erp

return programa, ok

end function
