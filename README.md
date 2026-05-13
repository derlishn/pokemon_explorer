<h1 align="center">🚀 Pokémon Explorer</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38.9-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.10.8-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Version" />
  <img src="https://img.shields.io/badge/GetX-State%20Management-blue?style=for-the-badge&logo=get&logoColor=white" alt="GetX" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Arquitectura-Clean%20Modular-green?style=flat-square" alt="Architecture" />
  <img src="https://img.shields.io/badge/Tests-100%25%20Pasando-brightgreen?style=flat-square&logo=dart" alt="Tests" />
  <img src="https://img.shields.io/badge/Licencia-MIT-yellow.svg?style=flat-square" alt="License" />
</p>

---

## Descripción

Pokémon Explorer es una aplicación móvil y de escritorio desarrollada con Flutter que permite a los usuarios explorar el catálogo de Pokémon consumiendo la [PokeAPI](https://pokeapi.co/). El proyecto ha sido diseñado bajo principios de **Clean Architecture** para garantizar la escalabilidad, la facilidad de testeo y el desacoplamiento de componentes.

## Tecnologías y Herramientas

- **Lenguaje**: Dart 3.10.8
- **Framework**: Flutter 3.38.9
- **Gestión de Estado**: GetX (Reactividad y Dependencias)
- **Persistencia**: GetStorage (Caché local)
- **Navegación**: GetX Routing con Middleware
- **Pruebas**: Mocktail (Unit Testing)

## Arquitectura del Proyecto

El código se organiza de manera modular siguiendo una estructura orientada a características (*Feature-driven*):

- **Core**: Contiene la infraestructura base, configuración de red, temas globales y utilidades compartidas.
- **Features**: Cada funcionalidad (Auth, Pokemon, Favorites, Settings) está encapsulada en su propio módulo, separando la lógica de datos de la presentación.
- **Services**: Servicios globales que gestionan el estado persistente de la aplicación (Autenticación, Favoritos, Preferencias).
- **Routes**: Definición centralizada de la navegación y protección de rutas.

## Características Implementadas

- **Consumo de API REST**: Integración completa con PokeAPI para obtener listas y detalles.
- **Caché Offline**: Implementación de una capa de repositorio que prioriza el almacenamiento local para mejorar la experiencia del usuario.
- **Diseño Responsivo**: Interfaz adaptada automáticamente para dispositivos móviles y resoluciones de escritorio.
- **Búsqueda Avanzada**: Sistema de búsqueda con *debounce* para optimizar las peticiones de red.
- **Gestión de Favoritos**: Persistencia local de Pokémon marcados por el usuario.

## Capturas de Pantalla

| Vista Móvil | Vista Escritorio |
| :---: | :---: |
| <img src="screenshots/mobile.png" width="250" alt="Vista Móvil" /> | <img src="screenshots/desktop.png" width="500" alt="Vista Escritorio" /> |

---

## Instalación y Ejecución

Para clonar y ejecutar esta aplicación localmente, sigue estos pasos:

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/derlishn/pokemon_explorer.git
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   - Para móvil/escritorio:
     ```bash
     flutter run
     ```
   - Para versiones específicas:
     ```bash
     flutter run -d chrome  # Web
     flutter run -d macos   # macOS
     ```

## Ejecución de Tests

Para validar la integridad del código, puedes ejecutar la suite de pruebas unitarias:

```bash
flutter test --reporter expanded
```

---
*Este proyecto es una demostración técnica de implementación de arquitectura limpia y manejo de estados en Flutter.*
