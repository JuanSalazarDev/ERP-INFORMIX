#!/bin/bash

# Generar archivos .4go
find . -type f -name "*.4gl" | xargs -I {} fglpc {}

# Generar archivos .frm
find . -type f -name "*.per" | xargs -I {} form4gl {}

# Mover formularios .frm
for archivo_frm in $(find . -type f -name "*.frm"); do
	directorio=$(echo ${archivo_frm} | cut -d "/" -f 3)

	if [[ ! -d ./bin/${directorio}/frm.d ]]; then
		mkdir -p ./bin/${directorio}/frm.d
	fi

	mv ${archivo_frm} ./bin/${directorio}/frm.d
done

# Mover archivos .4go
for archivo_4gl in $(find . -type f -name "*.4gl"); do
	archivo_4go="$(echo ${archivo_4gl} | awk -F "/" '{print $NF}' | cut -d "." -f 1).4go"
	directorio=$(echo ${archivo_4gl} | awk -F "/" '{for(i=3; i<NF; i++){printf "%s/", $i}; print ""}' | \
		sed 's/4gl.d/4go.d/g')

	if [[ ! -d ./bin/${directorio} ]]; then
		mkdir -p ./bin/${directorio}
	fi

	mv ./${archivo_4go} ./bin/${directorio}
done

# Programa login
cat bin/login/4go.d/login.4go bin/biblioteca/4go.d/servicios_de_claves.4go \
	bin/tablas/4go.d/claves_usuarios.4go bin/tablas/4go.d/usuarios.4go \
	bin/biblioteca/4go.d/servicios_de_programas.4go> bin/login/login.4gi

cat bin/menu/4go.d/menu.4go bin/tablas/4go.d/servicios/programas_usuario.4go \
	bin/biblioteca/4go.d/servicios_de_programas.4go bin/tablas/4go.d/usuarios.4go \
	bin/tablas/4go.d/programas_erp.4go > bin/menu/menu.4gi
