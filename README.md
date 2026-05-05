
# ERP INFORMIX

Este repositorio contiene la base inicial de un sistema ERP desarrollado utilizando Informix 4GL e Informix SQL como tecnologías principales. El objetivo del proyecto es construir una aplicación empresarial capaz de gestionar diferentes módulos de forma centralizada.

Actualmente, el sistema cuenta con un módulo de autenticación (login) completamente funcional, encargado de validar el acceso de usuarios. Además, incluye un menú principal dinámico que está diseñado para mostrar las opciones disponibles según el perfil de cada usuario.

Si bien la estructura general del sistema ya está definida, los módulos funcionales del ERP (como inventario, ventas o contabilidad) aún no han sido implementados, por lo que el menú no dispone de programas activos en este momento.

Este proyecto representa una base sólida para continuar el desarrollo de un ERP más completo y sirve como referencia para la implementación de control de acceso y estructura de aplicaciones utilizando Informix 4GL e Informix SQL.

## SETUP DEL PROYECTO

#### ***IMPORTANTE:***

*Todos los scripts deben ejecutarse desde el directorio central o directorio **utils**, tanto los scripts de release, compilación, ejecucion, debbug y rollback*

#### EJECUTAR SCRIPT DE RELEASE:

* Crear tablas e insertar información inicial necesaria.

```bash
  bash ./utils/release.sh
```

#### EJECUTAR SCRIPT DE COMPILACIÓN: 

* Compilar los formularios (***.per***) y módulos (***.4gl***). 
* Crear directorios **bin**.
* Crear programas de ***login*** y ***menu principal*** los cuales se ejecutarán a continuación.

```bash
  bash ./utils/compilar.sh
```

#### EJECUTAR SCRIPT DE INICIO DEL ERP:

* Ejecutar programas de login y menú principal.

```bash
  bash ./utils/iniciar_erp.sh
```

#### DEBUGGER:

* Debuggear programas.

```bash
  bash ./utils/debugger.sh <programa.4gi>
```

#### DESHACER RELEASE

* Eliminar tablas y bases de datos del ERP

```bash
  bash ./utils/rollback.sh
```
## SCREENSHOT

#### PANTALLA LOGIN

![PantallaLogin](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaLogin.png)

![PantallaLoginUsuario](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaLoginUsuario.png)

#### PANTALLA CAMBIO CLAVE

![PantallaLoginCambioClave](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaLoginCambioClave.png)

![PantallaLoginClavesNoCoinciden](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaLoginCambioClaveClavesNoCoinciden.png)

![PantallaLoginClaveActualizada](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaLoginClaveActualizada.png)

#### PANTALLA MENU

![PantallaMenu_1](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaMenu_1.jpeg)

![PantallaMenu_2](https://github.com/JuanSalazarDev/ERP-INFORMIX/blob/main/images/PantallaMenu_2.jpeg)
