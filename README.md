<p align="center">
  <img src="pokemon_explorer_banner_1778686412154.png" width="100%" alt="Pokémon Explorer Banner" />
</p>

<h1 align="center">🚀 Pokémon Explorer</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38.9-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.10.8-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Version" />
  <img src="https://img.shields.io/badge/GetX-State%20Management-blue?style=for-the-badge&logo=get&logoColor=white" alt="GetX" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-Clean%20%26%20Modular-green?style=flat-square" alt="Architecture" />
  <img src="https://img.shields.io/badge/Tests-100%25%20Passing-brightgreen?style=flat-square&logo=dart" alt="Tests" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square" alt="License" />
</p>

<p align="center">
  <strong>Un explorador de Pokémon de alto rendimiento, diseñado con Clean Architecture y Reactividad Total.</strong>
</p>

---

## 📊 Especificaciones Técnicas

El proyecto está construido sobre las versiones más recientes y estables del ecosistema Flutter para garantizar la máxima compatibilidad y rendimiento.

---

## 📁 Folder Structure & Architecture

The project follows a modular architecture designed for high maintainability:

*   **`lib/core/`**: The foundation of the app.
    *   `config/`: API and Avatar configurations.
    *   `constants/`: Centralized strings, keys, and translation maps.
    *   `network/`: Base `ApiClient` with connectivity interceptors and error handling.
    *   `theme/`: Dynamic Design System (Light/Dark mode).
    *   `widgets/`: Shared UI components used across multiple features.
*   **`lib/features/`**: Modular logic grouped by functionality.
    *   `auth/`: Login flow and credential management.
    *   `pokemon/`: Main explorer, infinite scroll, and detailed views.
    *   `favorites/`: User-saved Pokémon management.
    *   `settings/`: Dynamic configuration (Theme, Language, Cache).
*   **`lib/services/`**: Global reactive services (Auth, Favorites, Settings).
*   **`lib/routes/`**: Centralized routing engine with middleware support.

---

## 🚀 Getting Started

Follow these steps to run the project locally:

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/pokemon_explorer.git
cd pokemon_explorer
```

### 2. Install Dependencies
Ensure you have Flutter 3.38.9 installed:
```bash
flutter pub get
```

### 3. Run the Application
```bash
flutter run
```

---

## 🧪 Testing & Quality Assurance

This project includes a comprehensive suite of unit tests for all critical layers:

*   **Run all tests**: `flutter test`
*   **Detailed view**: `flutter test --reporter expanded`
*   **Check code quality**: `dart analyze`

---
*Developed as a high-quality demonstration of modern Flutter development.*
