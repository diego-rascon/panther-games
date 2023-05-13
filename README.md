# Panther Games

![Panther Games Banner](https://i.imgur.com/Fbmm6p5.png "Panther Games")

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

La aplicación está desarrollada con Sveltekit utilizando Typescript, un framework que usa Svelte como su UI framework. También se utiliza Tailwind CSS para estilizar el proyecto y Tauri para ejecutar la aplicación en el escritorio, con un backend en Supabase.

<a id="working-with-the-proyect"></a>

## Trabajando con el Proyecto

<a id="prerequisites"></a>

### Requisitos Prévios

Para trabajar con la versión web del proyecto, solo se requiere de Node.js. Si se desea trabajar con la versión de escritorio del proyecto usando Tauri en Windows 10/11, se requieren los siguientes componentes:

- Microsoft Visual Studio C++ Build Tools.
- Rust.

Para más información y para conocer los requisitos para macOS y Linux, favor de seguir las instrucciones listadas en <https://tauri.app/v1/guides/getting-started/prerequisites>.
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
# ejecutando el proyecto con Tauri
npm run tauri dev

# ejecutando el proyecto en el navegador
npm run dev
```

<a id="building"></a>

### Construcción

El proyecto puede ser construido para la web o como un instalador para una aplicación nativa de escritorio con Tauri.

Actualmente Tauri solo es capaz de construir instaladores para la plataforma en la que se está usando, es por eso que el archivo que es compilado solo puede ser uno de los siguientes:

- Windwos: *-setup.exe*, *.msi*.
- macOS: *.app*, *.dmg*.
- Linux: *.deb*, *.appimage*.

```bash
# construyendo instaladores para la plataforma actual
npm run tauri build

# construyendo el proyecto para la web
npm run build
```

<a id="credits"></a>

## Créditos

La planeación y desarrollo de este software fue completamente hecha por:

- Dulce Roxanna Clark Valenzuela ([fungirox](https://github.com/fungirox)).
- José Antonio Vega Saenz ([TonyDWKR](https://github.com/TonyDWKR)).
- José Diego Rascón Amador ([diego-rascon](https://github.com/diego-rascon)).
