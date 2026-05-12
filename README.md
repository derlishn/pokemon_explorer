# 🔴 Pokémon Explorer

A premium, high-performance Flutter application built with **Material 3**, **GetX**, and a clean modular architecture. Explore the vast world of Pokémon with a state-of-the-art interface.

## 🚀 Key Features

-   **Material 3 Adaptive Design**: Seamless experience across Android, iOS, Windows, and macOS.
-   **Dynamic Navigation**: Intelligent sidebar for desktop and fluid bottom navigation for mobile.
-   **Advanced State Management**: Powered by GetX for reactive and efficient performance.
-   **Skeleton Loading**: Premium UX using shimmer effects for a smoother data-fetching experience.
-   **Internationalization (i18n)**: Fully prepared for multiple languages (Spanish & English included).
-   **Local Persistence**: Favorites and user settings saved locally using `GetStorage`.
-   **Clean Architecture**: Strictly organized into Data, Presentation, and Service layers.

## 🛠 Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/)
-   **State Management**: [GetX](https://pub.dev/packages/get)
-   **API Consumption**: [Http](https://pub.dev/packages/http)
-   **Caching**: [Cached Network Image](https://pub.dev/packages/cached_network_image)
-   **Storage**: [GetStorage](https://pub.dev/packages/get_storage)
-   **Design System**: [Material 3](https://m3.material.io/)

## 📂 Project Structure

```text
lib/
├── data/           # Models and Repositories
├── services/       # Global services (API, Storage)
├── routes/         # Navigation management
├── helpers/        # Constants, i18n, utilities
├── theme/          # M3 Custom Themes (Light/Dark)
└── presentation/   # UI Modules (Splash, Login, Home, Detail)
    ├── layouts/    # Adaptive layout wrappers
    └── common/     # Reusable premium widgets
```

## 🏁 Getting Started

### Prerequisites

-   Flutter SDK (^3.10.8)
-   Dart SDK (^3.10.8)

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/derlisdev/POKEMON.git
    ```
2.  Navigate to the project folder:
    ```bash
    cd pokemon_explorer
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application:
    ```bash
    flutter run
    ```

---

*Built with ❤️ by derlisdev*
