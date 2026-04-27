#
# ============================================================================================================
# MODULO: claves_usuarios.4gl
# EJECUTABLE:
# DESCRIPCION: Rutinas de acceso, insercion, actualizacion, eliminacion en tabla "claves_usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 19/04/2026
# ============================================================================================================
#
database control_erp
#
# ============================================================================================================
# FUNCION: obtener_salt_t_claves_usuarios()
# OBJETIVO: Obtener salt de clave de la tabla "claves_usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 31/03/2026
# ============================================================================================================
#
function obtener_salt_t_claves_usuarios(id_usuario)

define
	id_usuario    like claves_usuarios.id_usuario, # ID usuario
	salt          like claves_usuarios.salt,       # Salt de clave
	sentencia_sql char(4800),                      # Sentencia SQL
	ok            smallint                         # Indicador estado transaccion

initialize salt, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select salt from claves_usuarios ",
	"where id_usuario = ? "
prepare p_obtener_salt_t_claves_usuarios from sentencia_sql
declare d_obtener_salt_t_claves_usuarios cursor with hold for p_obtener_salt_t_claves_usuarios
free p_obtener_salt_t_claves_usuarios

open d_obtener_salt_t_claves_usuarios using id_usuario
fetch d_obtener_salt_t_claves_usuarios into salt

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close d_obtener_salt_t_claves_usuarios
free d_obtener_salt_t_claves_usuarios

return salt, ok

end function
#
# ============================================================================================================
# FUNCION: obtener_clave_t_claves_usuarios()
# OBJETIVO: Obtener clave de usuario de la tabla "claves_usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 31/03/2026
# ============================================================================================================
#
function obtener_clave_t_claves_usuarios(id_usuario)

define
	id_usuario     like claves_usuarios.id_usuario, # ID usuario
	clave          like claves_usuarios.clave,      # Clave usuario
	sentencia_sql  char(4800),                      # Sentencia SQL
	ok             smallint                         # Indicador estado transaccion

initialize clave, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select clave from claves_usuarios ",
	"where id_usuario = ? "
prepare p_obtener_clave_t_claves_usuarios from sentencia_sql
declare d_obtener_clave_t_claves_usuarios cursor with hold for p_obtener_clave_t_claves_usuarios
free p_obtener_clave_t_claves_usuarios

open d_obtener_clave_t_claves_usuarios using id_usuario
fetch d_obtener_clave_t_claves_usuarios into clave

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close d_obtener_clave_t_claves_usuarios
free d_obtener_clave_t_claves_usuarios

return clave, ok

end function
#
# ============================================================================================================
# FUNCION: actualizar_clave_usuario()
# OBJETIVO: Actualizar clave de usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function actualizar_clave_usuario(id_usuario, salt, nueva_clave)

define
        id_usuario    like claves_usuarios.id_usuario, # ID usuario
        salt          like claves_usuarios.salt,       # Salt clave usuario
        nueva_clave   like claves_usuarios.clave,      # Nueva clave usuario
        sentencia_sql char(4800)                       # Sentencia SQL

initialize sentencia_sql to null

let sentencia_sql =
        "update claves_usuarios set salt = ?, clave = ? ",
        "where id_usuario = ? "
prepare p_actualizar_clave_usuario from sentencia_sql
execute p_actualizar_clave_usuario using salt, nueva_clave, id_usuario

if sqlca.sqlcode != 0
        then
        return false
end if

return true

end function
