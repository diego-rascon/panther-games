![Alt text](https://scontent.fhmo2-2.fna.fbcdn.net/v/t39.30808-6/313400996_556025363189810_8246496044028966806_n.png?_nc_cat=105&ccb=1-7&_nc_sid=dd9801&efg=eyJpIjoidCJ9&_nc_ohc=L_fCLpuSOBwAX8Jj92Q&tn=Bvw84NPuymUTOPhx&_nc_ht=scontent.fhmo2-2.fna&oh=00_AfAAyR43yj9GVeCQvJNonE4mMBGMv6sT-i5WC9ZE3xSp4A&oe=6435FBA3 "Panther Games")
# Panther Games
## Tabla de Contenido
- [Introducción](#introduction)
- [Trabajando con el Proyecto](#working-with-the-proyect)
  - [Requisitos Prévios](#prerequisites)
  - [Recomendaciones](#recommendations)
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
<a id="recommendations"></a>
### Recomendaciones
Se recomienda utilizar un editor de código como [Visual Studio Code](https://code.visualstudio.com/) para trabajar con el proyecto, así como las siguientes extensiones:
- [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag)
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [HTML CSS Support](https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css)
- [IntelliCode](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode)
- [IntelliCode API Usage Examples](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.intellicode-api-usage-examples)
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer)
- [Svelte for VS Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode)
- [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)
- [Tauri](https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode)

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
- Dulce Roxanna Clark Valenzuela ([fungirox](https://github.com/fungirox)).
- Gabriel Alejandro Ibarra López ([Galiblo](https://github.com/Galiblo)).
- José Antonio Vega Saenz ([TonyDWKR](https://github.com/TonyDWKR)).
- José Diego Rascón Amador ([diego-rascon](https://github.com/diego-rascon)).
