#
# ============================================================================================================
# MODULO: servicios_de_programas.4gl
# EJECUTABLE: 
# DESCRIPCION: Funciones para ejecutar en cada programa
# AUTOR: Juan Salazar
# FECHA CREACION: 19/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
database control_erp
#
# ============================================================================================================
# FUNCION: desplegar_cabecera_programa()
# OBJETIVO: Desplegar en pantalla informacion de programa
# AUTOR: Juan Salazar
# FECHA CREACION: 19/Abr/2026
# FECHA ULTIMA MODIFICACION: 01/May/2026
# ============================================================================================================
#
function desplegar_cabecera_programa(usuario, descripcion_programa)

define
	usuario              char(8),  # Programa
	complemento          char(8),  # Complemento nombre usuario
	diferencia           smallint, # Diferencia entre longitud cadena usuario y longitud maxima
	descripcion_programa char(20), # Descripcion programa
	fecha                date      # Fecha actual

let fecha = today using "dd/mm/yyyy"
let complemento = "________"
let diferencia = 8 - length(usuario)

if diferencia > 0
	then
	let usuario = usuario clipped, complemento[1, diferencia]
end if

display " USUARIO: ", usuario clipped, " " at 1, 1 attribute(reverse)
display descripcion_programa at 1, 21 attribute(reverse)
display " FECHA: ", fecha, " " at 1, 42 attribute(reverse)

end function
#
# ============================================================================================================
# FUNCION: centrar_texto()
# OBJETIVO: Centrar texto dato
# AUTOR: Juan Salazar
# FECHA CREACION: 19/Abr/2026
# FECHA ULTIMA MODIFICACION: 19/Abr/2026
# ============================================================================================================
#
function centrar_texto(texto, longitud_texto)

define
	texto          char(100), # Texto a centrar
	longitud_texto smallint,  # Longitud del texto a centrar
	texto_centrado char(100)  # Texto centrado

initialize texto_centrado to null

return texto_centrado

end function
