# Evede Takehome Assignment- Nimal Prince
## 🚀 Features

- **Immersive UI Design**: Modern Design with gradient backgrounds and smooth animations
- **Route Management**: Browse and select from available bus routes
- **Bus Stop Details**: View detailed information for each bus stop
- **Dark Mode Support**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for various screen sizes
- **Offline Support**: Local data storage using SharedPreferences


## 🛠️ Installation

1. **Prerequisites**
   - Flutter SDK (^3.5.4)
   - Dart SDK
   - Android Studio or VS Code with Flutter extensions

2. **Clone the repository**
   ```bash
   git clone https://github.com/Nimal-dev/Evide_TakeHome_Assignment-NIMAL-PRINCE.git
   cd evde_takehome
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart              # App entry point and theme configuration
├── screens/
│   ├── homepage.dart      # Main route selection screen
│   ├── busStopList.dart   # Bus stops list for selected route
│   └── stopDetails.dart   # Detailed bus stop information
└── utilities/
    └── BusStops.dart      # Bus stop data models and utilities

assets/
└── mock/
    └── stops.json         # Mock data for bus stops
```

## 🏗️ Architecture

- **State Management**: Uses Flutter's built-in state management
- **Data Storage**: SharedPreferences for local data persistence


## 📋 Dependencies

- `cupertino_icons`: iOS-style icons
- `shared_preferences`: Local data storage

## 🚀 Usage

1. Launch the app
2. Select a bus route from the homepage
3. Browse bus stops for the selected route
4. Tap on a bus stop to view detailed information

## 👨‍💻 Author

**Nimal Prince**
- GitHub: [@Nimal-dev](https://github.com/Nimal-dev)
