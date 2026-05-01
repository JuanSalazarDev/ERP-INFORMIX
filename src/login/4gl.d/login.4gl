#
# ============================================================================================================
# MODULO: login.4gl
# EJECUTABLE: login.4gi
# DESCRIPCION: Funciones de acceso a aplicacion
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
database control_erp
globals

define
        mensaje_error char(2000) # Mensaje de error generado

end globals

define
	id_usuario like usuarios.id # ID usuario
#
# ============================================================================================================
# FUNCION: main()
# DESCRIPCION: Inicio ejecucion programa
# AUTOR: Juan Salazar
# FECHA CREACION: 21/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
main

defer interrupt

call desplegar_cabecera_programa("", "     L O G I N      ")

if solicitar_acceso() = false
        then
        exit program 1
end if

exit program 0

end main
#
# ============================================================================================================
# FUNCION: solicitar_acceso()
# OBJETIVO: Solicitar acceso a la aplicacion
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function solicitar_acceso()

define
	usuario like usuarios.usuario,      # Usuario
	clave   like claves_usuarios.clave, # Clave acceso
	cmd     char(4800)                  # Comando

initialize usuario, clave to null

open window w_solicitar_acceso at 3, 11 with form "./bin/login/frm.d/login" attribute(border, form line 1)

display "     I N G R E S O" to field_1 attribute(reverse)
display "     =============" to field_2 attribute(yellow)

input by name usuario, clave without defaults

	before field usuario
		display by name usuario attribute(reverse, underline)

	after field usuario
		-- Se carga variable "id_usuario"
		if verificar_usuario(usuario) = false
			then
			error mensaje_error clipped
			initialize usuario, clave to null
			next field usuario
		end if

		if debe_cambiar_clave_primer_acceso(id_usuario) = true
        		then
			error "Usuario ", usuario clipped, " debe cambiar clave por primer acceso"

			if cambiar_clave(id_usuario, false) = false
				then
				error mensaje_error clipped
				next field usuario
			end if
		end if

		display by name usuario attribute(reverse)

	after field clave
		if verificar_clave_usuario(id_usuario, clave) = false 
			then
			error mensaje_error clipped
			initialize clave to null
			next field usuario
		end if

		exit input

end input

close window w_solicitar_acceso

if int_flag = true
	then
	let int_flag = false
	return false
end if

if escribir_id_usuario_acceso(id_usuario) = false
	then
	error mensaje_error clipped
	return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: verificar_usuario()
# OBJETIVO: Realizar verificaciones del usuario de acceso
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function verificar_usuario(usuario)

define
        usuario like usuarios.usuario, # Usuario
	ok      smallint               # Indicador estado transaccion

initialize id_usuario, ok to null

if usuario is null or length(usuario) = 0
        then
        let mensaje_error = "Debe indicar usuario"
        return false
end if

call obtener_id_usuario_t_usuarios(usuario) returning id_usuario, ok

if ok = false
        then
        let mensaje_error = "Usuario '", usuario clipped, "' no existe, contacte al administrador"
        return false
end if

return true

end function
#
# ============================================================================================================
# FUNCION: debe_cambiar_clave_primer_acceso()
# OBJETIVO: Verificar si el usuario debe cambiar clave por primer acceso
# AUTOR: Juan Salazar
# FECHA CREACION: 27/Mar/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function debe_cambiar_clave_primer_acceso(id_usuario)

define
        id_usuario like usuarios.id,           # ID usuario acceso
	salt       like claves_usuarios.salt,  # Salt de clave usuario
	clave      like claves_usuarios.clave, # Clave usuario
	ok         smallint                    # Indicador estado transaccion

initialize salt, clave to null

call obtener_salt_t_claves_usuarios(id_usuario) returning salt, ok
call obtener_clave_t_claves_usuarios(id_usuario) returning clave, ok

if (salt is null and clave is null) or (length(salt) = 0 and length(clave) = 0)
	then
	return true
end if

return false

end function
#
# ============================================================================================================
# FUNCION: escribir_id_usuario_acceso
# OBJETIVO: Escribir en un archivo el usuario que accedio al sistema
# AUTOR: Juan Salazar
# FECHA CREACION: 21/Abr/2026
# FECHA ULTIMA MODIFICACION: 21/Abr/2026
# ============================================================================================================
#
function escribir_id_usuario_acceso(id_usuario)

define
	id_usuario like usuarios.usuario, # Usuario
	cmd        char(4800),            # Comando
	ok         smallint,              # Indicador estado transaccion
	archivo    char(1000)             # Archivo donde se almacenara usuario de acceso

initialize cmd, ok, archivo to null

let archivo = arg_val(1)

if archivo is null or length(archivo) = 0
	then
	let mensaje_error = "No se indico archivo trabajo usuario, contacte al administrador"
	return false
end if

let cmd = "echo '", id_usuario using "<<<<<<<<", "' > ", archivo clipped
run cmd returning ok

if ok != 0
	then
	let mensaje_error = "No es posible ingresar al sistema, contacte al administrador"
	return false
end if

return true

end function
