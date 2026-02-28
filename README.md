# Breathing App (newu_task)

A beautiful, responsive, and cross-platform Flutter application designed to guide users through customizable breathing exercises for relaxation and mindfulness. 

---

## 🌟 Features

*   **Customizable Breathing Cycles:** 
    *   **Simple Mode:** Set a universal duration (in seconds) for inhaling, holding, exhaling, and holding out.
    *   **Advanced Mode:** Granular control over each phase of the breathing cycle (`breathe in`, `hold in`, `breathe out`, `hold out`).
*   **Customizable Rounds:** Choose the number of breathing rounds per session.
*   **Visual Guidance:** Smooth Lottie animations and progress indicators guide you through each breathing phase (`prepare`, `breatheIn`, `holdIn`, `breatheOut`, `holdOut`).
*   **Audio Support:** Optional breathing sounds (`audioplayers`) to synchronize your breath even with your eyes closed.
*   **State Management:** Robust architecture using **Flutter BLoC** for predictable state transitions during the exercise.
*   **Local Storage:** User preferences are persisted locally using **Hive**, ensuring your settings are saved across sessions.
*   **Theming & Responsiveness:** 
    *   Supports both **Light and Dark modes** seamlessly.
    *   Fully cross-platform, including optimized UI for **Web**.

---

## 🏗️ Codebase Architecture

The project follows a clean, feature-driven folder structure inside the `lib/` directory:

### `lib/core/`
Contains core application configurations and utilities.
*   **`theme.dart`**: Defines the light and dark `ThemeData`, text themes (using `GoogleFonts` / local fonts like Quicksand), and consistent colors.
*   **`utils.dart`**: General utility functions used across the application.

### `lib/models/`
Contains data models and local storage adapters.
*   **`breathing_preferences.dart`**: The core data model defining the user's breathing settings (duration, rounds, sounds, advanced timing). Annotated with `@HiveType` for local storage.
*   **`breathing_preferences.g.dart`**: The Hive TypeAdapter generated code for `BreathingPreferences`.

### `lib/logic/`
Handles the business logic using the BLoC pattern.
*   **`settings_bloc/`**: Manages the loading, updating, and saving of the user's `BreathingPreferences` from/to Hive storage.
*   **`breathing_bloc/`**: Controls the active breathing session. It manages the timer, tracks the current cycle and phase (`BreathingPhase`), and calculates the overall progress.

### `lib/ui/`
The presentation layer, divided into screens and reusable widgets.
*   **`screens/`**:
    *   `settings_page.dart`: The home screen where users configure their breathing session preferences.
    *   `breathing_page.dart`: The active exercise screen containing the UI for animations, progress, and phase instructions.
    *   `completion_page.dart`: The summary screen shown after successfully completing a session.
*   **`widgets/`**:
    *   `background_wrapper.dart`: A responsive background container handling different abstract background images for light/dark and web/mobile platforms.
    *   `smooth_progress.dart`: A custom animated progress bar indicating the overall session completion.

### `lib/main.dart`
The entry point of the app. Initializes Flutter bindings, sets up Hive, preloads assets (like background images), provides the global `SettingsBloc`, and handles high-level theme toggling via `MyAppState`.

---

## 🚀 Getting Started

### Prerequisites
Make sure you have [Flutter](https://docs.flutter.dev/get-started/install) installed (SDK ^3.9.0).

### Installation

1.  **Get Packages:**
    Run the following command in the project root to fetch all dependencies from `pubspec.yaml`:
    ```bash
    flutter pub get
    ```

2.  **Run the App:**
    You can run the app on your preferred connected device or emulator:
    ```bash
    flutter run
    ```

    *To run specifically on Web with a specific mode (optional):*
    ```bash
    flutter run -d chrome 
    ```

### Generating Hive Adapters (If modifying models)
If you make changes to `lib/models/breathing_preferences.dart`, you need to regenerate the Hive adapter:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 🛠️ Tech Stack & Dependencies

*   **Flutter & Dart**
*   **State Management:** `flutter_bloc`
*   **Local Database:** `hive`, `hive_flutter`
*   **Animations:** `lottie`
*   **Audio:** `audioplayers`
*   **Styling:** `google_fonts`, `flutter_svg`
*   **Utils:** `equatable`, `collection`, `path_provider`

Enjoy a moment of relaxation! 🧘‍♂️
