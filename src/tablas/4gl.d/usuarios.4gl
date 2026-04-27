#
# ============================================================================================================
# MODULO: usuarios.4gl
# EJECUTABLE:
# DESCRIPCION: Rutinas de acceso, insercion, actualizacion, eliminacion en tabla "usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 19/04/2026
# ============================================================================================================
#
database control_erp
#
# ============================================================================================================
# FUNCION: obtener_id_usuario_t_usuarios()
# OBJETIVO: Obtener id de usuario de tabla "usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 19/04/2026
# ============================================================================================================
#
function obtener_id_usuario_t_usuarios(usuario)

define
	usuario       like usuarios.usuario, # Usuario
	id_usuario    like usuarios.id,      # ID usuario
	sentencia_sql char(4800),            # Sentencia SQL
	ok            smallint               # Indicador estado transaccion

initialize id_usuario, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select id from usuarios ",
	"where usuario = ? "
prepare p_obtener_id_usuario_t_usuarios from sentencia_sql
declare c_obtener_id_usuario_t_usuarios cursor with hold for p_obtener_id_usuario_t_usuarios
free p_obtener_id_usuario_t_usuarios

open c_obtener_id_usuario_t_usuarios using usuario
fetch c_obtener_id_usuario_t_usuarios into id_usuario

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close c_obtener_id_usuario_t_usuarios
free c_obtener_id_usuario_t_usuarios

return id_usuario, ok

end function
#
# ============================================================================================================
# FUNCION: obtener_usuario_t_usuarios()
# OBJETIVO: Obtener usuario de la tabla "usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 19/04/2026
# ============================================================================================================
#
function obtener_usuario_t_usuarios(id_usuario)

define
	id_usuario    like usuarios.id,      # ID usuario
	usuario       like usuarios.usuario, # Usuario
	sentencia_sql char(4800),            # Sentencia SQL
	ok            smallint               # Indicador estado transaccion

initialize usuario, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select usuario from usuarios ",
	"where id_usuario = ? "
prepare p_obtener_usuario_t_usuarios from sentencia_sql
declare d_obtener_usuario_t_usuarios cursor with hold for p_obtener_usuario_t_usuarios
free p_obtener_usuario_t_usuarios

open d_obtener_usuario_t_usuarios using id_usuario
fetch d_obtener_usuario_t_usuarios into usuario

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close d_obtener_usuario_t_usuarios
free d_obtener_usuario_t_usuarios

return usuario, ok

end function
#
# ============================================================================================================
# FUNCION: obtener_fecha_de_alta_t_usuarios()
# OBJETIVO: Obtener fecha de alta de usuario de la tabla "usuarios"
# AUTOR: Juan Salazar
# FECHA CREACION: 31/03/2026
# FECHA ULTIMA MODIFICACION: 19/04/2026
# ============================================================================================================
#
function obtener_fecha_de_alta_t_usuarios(id_usuario)

define
	id_usuario    like usuarios.id,         # ID usuario
	fecha_alta    like usuarios.fecha_alta, # Fecha creacion usuario
	sentencia_sql char(4800),               # Sentencia SQL
	ok            smallint                  # Indicador estado transaccion

initialize fecha_alta, sentencia_sql, ok to null

let ok = true

let sentencia_sql =
	"select fecha_alta from usuarios ",
	"where id_usuario = ? "
prepare p_obtener_fecha_alta_t_usuarios from sentencia_sql
declare c_obtener_fecha_alta_t_usuarios cursor with hold for p_obtener_fecha_alta_t_usuarios
free p_obtener_fecha_alta_t_usuarios

open c_obtener_fecha_alta_t_usuarios using id_usuario
fetch c_obtener_fecha_alta_t_usuarios into fecha_alta

if sqlca.sqlcode != 0
	then
	let ok = false
end if

close c_obtener_fecha_alta_t_usuarios
free c_obtener_fecha_alta_t_usuarios

return fecha_alta, ok

end function
