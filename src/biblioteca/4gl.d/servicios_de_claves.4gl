#
# ============================================================================================================
# MODULO: servicios_de_claves.4gl
# EJECUTABLE: 
# DESCRIPCION: Funciones relacionadas a claves
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
database control_erp
globals

define
	mensaje_error char(2000) # Mensaje de error generado

end globals
#
# ============================================================================================================
# FUNCION: cambiar_clave()
# OBJETIVO: Cambiar clave usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function cambiar_clave(id_usuario, solicitar_clave_anterior)

define
	id_usuario               like usuarios.id,           # ID usuario
	solicitar_clave_anterior smallint,                   # Indicador para solicitar clave anterior
	clave_anterior           like claves_usuarios.clave, # Clave anterior
	nueva_clave              like claves_usuarios.clave, # Nueva clave
	conf_nueva_clave         like claves_usuarios.clave  # Confirmacion nueva clave

initialize clave_anterior, nueva_clave, conf_nueva_clave to null

open window w_cambiar_clave at 3, 10 with form "./bin/biblioteca/frm.d/cambiar_clave" 
	attribute(border, form line 1)

if solicitar_clave_anterior = true
	then
	display "CLAVE ANTERIOR" to mensaje attribute(yellow)
	display "--------------" to subrayado attribute(yellow)
end if

input by name clave_anterior, nueva_clave, conf_nueva_clave without defaults

	before field clave_anterior
		if solicitar_clave_anterior = false
			then
			let clave_anterior = "      C A M B I O   C L A V E"
			display by name clave_anterior attribute(yellow)
			next field nueva_clave
		end if

	after field clave_anterior
		if verificar_clave_usuario(id_usuario, clave_anterior) = false
			then
			error mensaje_error clipped
			initialize clave_anterior to null
			next field clave_anterior
		end if

	after field nueva_clave
		if nueva_clave is null or length(nueva_clave) = 0
			then
			error "Debe indicar clave"
			initialize nueva_clave, conf_nueva_clave to null
			next field nueva_clave
		end if

	after field conf_nueva_clave
		if nueva_clave != conf_nueva_clave
			then
			error "Claves no coinciden"
			initialize nueva_clave, conf_nueva_clave to null
			next field nueva_clave
		end if

		exit input

end input

close window w_cambiar_clave

if int_flag = true
	then
	let int_flag = false
	return false
end if

if establecer_nueva_clave(id_usuario, nueva_clave) = false
	then
	error mensaje_error clipped
	return false
end if

error "Clave actualizada"

return true

end function
#
# ============================================================================================================
# FUNCION: verificar_clave_usuario()
# OBJETIVO: Verificar que la clave indicada corresponde al usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function verificar_clave_usuario(id_usuario, clave)

define
	id_usuario       like usuarios.id,           # ID usuario
	clave            like claves_usuarios.clave, # Clave anterior
	clave_almacenada like claves_usuarios.clave, # Clave almacenada del usuario
	salt             like claves_usuarios.salt,  # Salt clave usuario
	clave_hash       like claves_usuarios.clave, # Clave hasheada
	ok               smallint                    # Indicador estado transaccion

initialize clave_almacenada, salt, clave_hash, ok to null

if clave is null or length(clave) = 0
	then
	let mensaje_error = "Debe indicar clave"
	return false
end if

call obtener_clave_t_claves_usuarios(id_usuario) returning clave_almacenada, ok

call obtener_salt_t_claves_usuarios(id_usuario) returning salt, ok

let clave_hash = hashear_clave(salt, clave)

if clave_hash is null or length(clave_hash) = 0
	then
	let mensaje_error = "No es posible verificar clave"
	return false
end if

if clave_hash != clave_almacenada
	then
	let mensaje_error = "Clave incorrecta"
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: hashar_clave()
# OBJETIVO: Generar hash de clave
# AUTOR: Juan Salazar
# FECHA CREACION: 28/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function hashear_clave(salt, clave)

define
	salt         like claves_usuarios.salt,  # Salt usuario
	clave        like claves_usuarios.clave, # Clave usuario
	clave_hash   like claves_usuarios.clave, # Clave hasheada
	archivo_hash char(1000),                 # Archivo con codigo hash
	cmd          char(4800)                  # Comando

initialize clave_hash, archivo_hash, cmd to null

let archivo_hash = "/tmp/hash_", salt clipped
let cmd = "rm -rf ", archivo_hash clipped, " 2>/dev/null"

if generar_hash(salt, clave, archivo_hash) = true
	then
	let clave_hash = cargar_hash_o_salt(archivo_hash)
end if

run cmd

return clave_hash

end function
#
# ============================================================================================================
# FUNCION: generar_hash()
# OBJETIVO: Generar hash con salt y clave pasados como parametro
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function generar_hash(salt, clave, archivo_hash)

define
	salt         like claves_usuarios.salt,  # Salt usuario
	clave        like claves_usuarios.clave, # Clave usuario
	archivo_hash char(1000),                 # Archivo con codigo hash
	cmd          char(4800),                 # Comando
	ok_hash      smallint                    # Indicador de que hash se genero correctamente

initialize cmd, ok_hash to null

let cmd =
	"echo '", salt clipped, clave clipped, "' | openssl dgst -sha256 | cut -d ' ' -f 2 > ",
	archivo_hash clipped

run cmd returning ok_hash

if ok_hash != 0
	then
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: cargar_hash_o_salt()
# OBJETIVO: Cargar hash o salt generado anteriormente
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function cargar_hash_o_salt(archivo)

define
	archivo   char(1000),                # Archivo con codigo hash o salt
	hash_salt like claves_usuarios.clave # Hash o salt generado

initialize hash_salt to null

if crear_tabla_temporal_hash_o_salt() = false
	then
	return hash_salt
end if

if cargar_hash_o_salt_tabla_temporal(archivo) = false
	then
	return hash_salt
end if

select hash into hash_salt from t_hash_salt

call eliminar_tabla_temporal_hash_o_salt()

return hash_salt

end function
#
# ============================================================================================================
# FUNCION: crear_tabla_temporal_hash_o_salt()
# OBJETIVO: Crear tabla temporal donde se cargara el hash o salt generado
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function crear_tabla_temporal_hash_o_salt()

whenever sqlerror continue
create temp table t_hash_salt(
	hash char(64)
) with no log
;
whenever sqlerror stop

if sqlca.sqlcode != 0
	then
	call eliminar_tabla_temporal_hash_o_salt()
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: eliminar_tabla_temporal_hash_o_salt()
# OBJETIVO: Eliminar tabla temporal donde se cargara el hash o salt generado
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function eliminar_tabla_temporal_hash_o_salt()

whenever sqlerror continue
drop table t_hash_salt
;
whenever sqlerror stop

end function
#
# ============================================================================================================
# FUNCION: cargar_hash_o_salt_tabla_temporal()
# OBJETIVO: Cargar hash o salt generado en tabla temporal
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function cargar_hash_o_salt_tabla_temporal(archivo)

define
	archivo char(1000) # Archivo con codigo hash o salt

whenever sqlerror continue
load from archivo
insert into t_hash_salt
;
whenever sqlerror stop

if sqlca.sqlcode != 0
	then 
	call eliminar_tabla_temporal_hash_o_salt()
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: establecer_nueva_clave()
# OBJETIVO: Establecer nueva clave usuario
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function establecer_nueva_clave(id_usuario, nueva_clave)

define
	id_usuario  like usuarios.id,           # ID usuario
	nueva_clave like claves_usuarios.clave, # Nueva clave usuario
	salt        like claves_usuarios.salt   # Salt clave usuario

initialize salt to null

let mensaje_error = "No fue posible actualizar clave"

let salt = generar_nuevo_salt()

if salt is null or length(salt) = 0
	then
	return false
end if

let nueva_clave = hashear_clave(salt, nueva_clave)

if nueva_clave is null or length(nueva_clave) = 0
	then
	return false
end if

if actualizar_clave_usuario(id_usuario, salt, nueva_clave) = false
	then
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: generar_nuevo_salt()
# OBJETIVO: Generar nuevo salt
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function generar_nuevo_salt()

define
	salt         like claves_usuarios.salt, # Salt clave usuario
	archivo_salt char(1000),                # Archivo con codigo salt
	cmd          char(4800)                 # Comando

initialize salt, archivo_salt, cmd to null

let archivo_salt = "/tmp/generacion_nuevo_salt_clave.tmp"
let cmd = "rm -rf ", archivo_salt clipped, " 2>/dev/null"

if generar_salt(archivo_salt) = true
	then
	let salt = cargar_hash_o_salt(archivo_salt)
end if

run cmd

return salt

end function
#
# ============================================================================================================
# FUNCION: generar_salt()
# OBJETIVO: Generar codigo salt
# AUTOR: Juan Salazar
# FECHA CREACION: 30/Mar/2026
# FECHA ULTIMA MODIFICACION: 30/Mar/2026
# ============================================================================================================
#
function generar_salt(archivo_salt)

define
	archivo_salt char(1000), # Archivo con codigo salt
	cmd          char(4800), # Comando
	ok_salt      smallint    # Indicador de que salt se genero correctamente

initialize cmd, ok_salt to null

let cmd = "openssl rand -hex 16 > ", archivo_salt clipped

run cmd returning ok_salt

if ok_salt != 0
	then
	return false
end if

return true

end function
