![Alt text](https://scontent.fcen1-1.fna.fbcdn.net/v/t39.30808-6/313400996_556025363189810_8246496044028966806_n.png?_nc_cat=105&ccb=1-7&_nc_sid=e3f864&_nc_ohc=uEeX4OIgdFYAX_gNAR4&_nc_ht=scontent.fcen1-1.fna&oh=00_AfDEZ5Yihv6g4P1hBfQJYl1juO6UZc2KRnwbCQHVRjcObg&oe=640C7463 "Panther Games")
# Panther Games
## Tabla de Contenido
- [Introducción](#introduction)
- [Trabajando con el Proyecto](#working-with-the-proyect)
  - [Requisitos Prévios](#prerequisites)
  - [Instalación](#instalation)
  - [Ejecución](#execution)
  - [Construcción](#building)
- [Créditos](#credits)

<a id="introduction"></a>
## Introducción
Panthes Games es un negocio ubicado en Cd. Obregón, Sonora que se dedica a vender artículos relacionados a videojugeos y a la cultura popular. Este es un punto de venta diseñado para uso interno del negocio y está desarrollado por alumnos de ITESCA que cursan la materia de ingeniería de software en la carrera de ingeniería en sistemas computacionales.

La aplicación está desarrollada con Sveltekit utilizando Typescript, un framework que usa Svelte como su UI framework. También se utiliza Tailwind CSS para estilizar el proyecto y Tauri para ejecutar la aplicación en el escritorio.

<a id="working-with-the-proyect"></a>
## Trabajando con el Proyecto
<a id="prerequisites"></a>
### Requisitos Prévios
Para trabajar con el proyecto en Windows 10/11, se requieren los siguientes componentes:
- Microsoft Visual Studio C++ Build Tools.
- Rust.
Favor de seguir las instrucciones listadas en https://tauri.app/v1/guides/getting-started/prerequisites.
<a id="instalation"></a>
### Instalación
Para preparar el proyecto, se utilizan los siguientes comandos:
```bash
# se clona el repositorio
git clone https://github.com/diego-rascon/panther-games.git 

# entramos a la carpeta
cd panther-games

# instalamos las dependencias de node.js
npm install
```
<a id="execution"></a>
### Ejecución
El proyecto puede ser ejecutado en su propia ventana utilizando Tauri o a través del navegador en un servidor local:
```bash
# ejecutando el proyecto con tauri
npm run tauri dev

# ejecutando el proyecto en el navegador
npm run dev
```
<a id="building"></a>
### Construcción
```bash
npm run build
```
<a id="credits"></a>
## Créditos
La planeación y desarrollo de este software fue completamente hecha por:
- Dulce Roxanna Clark Valenzuela.
- Gabriel Alejandro Ibarra López.
- José Antonio Vega Saenz.
- José Diego Rascón Amador.
