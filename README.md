# Sandwich Shop 🥪

A feature-rich Flutter application for ordering sandwiches with a modern, responsive UI. Built with Flutter and Dart, this app demonstrates best practices in state management, database integration, widget reusability, and comprehensive testing.

## ✨ Features

- **🎨 Sandwich Customization**: Choose sandwich type, size (6-inch or footlong), bread type, quantity, and add special notes
- **🛒 Smart Shopping Cart**: Real-time cart updates with Provider state management and persistent cart indicator
- **💳 Checkout & Payment**: Streamlined payment processing with order confirmation and estimated delivery time
- **📦 Order History**: View past orders with complete details, stored in local SQLite database
- **👤 User Profile**: Manage personal information including name and preferred location
- **⚙️ Settings**: Customize font size with persistent preferences across app restarts
- **🎯 Consistent UI**: Reusable CommonAppBar and CartIndicator components across all screens
- **🖥️ Cross-Platform**: Runs on Windows, macOS, Linux, Web, Android, and iOS
- **🧪 Comprehensive Testing**: 210+ tests with 100% pass rate including unit and integration tests

## 🌐 Live Demo

**Try it now**: [https://sandwich-shop-412f1.web.app](https://sandwich-shop-412f1.web.app)

The app is deployed on Firebase Hosting and available for immediate testing. No installation required - just click the link and start ordering!

**Firebase Console**: [Project Dashboard](https://console.firebase.google.com/project/sandwich-shop-412f1/overview)

## 📁 Project Structure

```
sandwich_shop/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── cart.dart             # Shopping cart with ChangeNotifier
│   │   └── sandwich.dart         # Sandwich model with enums
│   ├── views/                    # UI screens and styling
│   │   ├── order_screen.dart     # Main sandwich ordering screen
│   │   ├── cart_screen.dart      # Shopping cart view
│   │   ├── checkout_screen.dart  # Payment processing
│   │   ├── profile_screen.dart   # User profile management
│   │   ├── settings_screen.dart  # App settings
│   │   ├── order_history_screen.dart  # Past orders
│   │   ├── app_styles.dart       # Centralized styling
│   │   └── common_widgets.dart   # Reusable widgets (CommonAppBar, CartIndicator)
│   ├── repositories/             # Business logic
│   │   └── pricing_repository.dart  # Sandwich pricing calculations
│   ├── services/                 # External services
│   │   └── database_service.dart    # SQLite database operations
│   └── widgets/                  # Additional reusable widgets
├── test/                         # Unit tests (206+ tests)
│   ├── models/                   # Model tests
│   ├── views/                    # Widget tests for all screens
│   ├── repositories/             # Repository tests
│   └── helpers/                  # Test utilities
├── integration_test/             # E2E tests (4 tests)
│   └── app_test.dart             # End-to-end user flows
└── assets/                       # Images and resources
    └── images/
        └── logo.png
```

## 🛠️ Prerequisites

### Required Tools

1. **Terminal**:
   - **macOS**: Built-in Terminal app (⌘ + Space → "Terminal")
   - **Windows**: Command Prompt, PowerShell, or Windows Terminal
   - **Linux**: Your preferred terminal emulator

2. **Git**: Verify with `git --version`. If missing, download from [Git's official site](https://git-scm.com/downloads).

3. **Package Managers** (recommended):
   - **macOS**: Homebrew - `brew --version` ([Install Homebrew](https://brew.sh/))
   - **Windows**: Chocolatey - `choco --version` ([Install Chocolatey](https://chocolatey.org/install))
   - **Linux**: Use your distribution's package manager (apt, yum, pacman, etc.)

4. **Flutter SDK**: Verify with `flutter doctor`. Install using:
   - **macOS**: `brew install --cask flutter`
   - **Windows**: `choco install flutter`
   - **Linux**: [Flutter Linux Install Guide](https://docs.flutter.dev/get-started/install/linux)

5. **Visual Studio Code** (recommended): Verify with `code --version`
   - **macOS**: `brew install --cask visual-studio-code`
   - **Windows**: `choco install vscode`
   - **Linux**: [VS Code Linux Install](https://code.visualstudio.com/docs/setup/linux)

## 📥 Installation

### Clone the Repository

```bash
# Clone the project
git clone https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop

# Open in VS Code
code .
```

### Install Dependencies

```bash
# Install all dependencies
flutter pub get

# Verify installation
flutter doctor
```

## 🚀 Development Setup

### Check Available Devices

```bash
flutter devices
```

You should see available platforms like:
- Windows (desktop)
- Chrome (web)
- Edge (web)
- Android emulator/device (if configured)
- iOS simulator/device (macOS only)

### Platform-Specific Setup

**Windows Desktop**: No additional setup required

**Web**: Chrome or Edge browser installed

**Android**: 
- Install Android Studio
- Set up Android SDK
- Create an emulator or connect a device

**iOS** (macOS only):
- Install Xcode
- Set up iOS Simulator or connect an iOS device

## ▶️ Running the App

### Run on Different Platforms

```bash
# Web (Chrome)
flutter run -d chrome

# Web (Edge)
flutter run -d edge

# Windows Desktop
flutter run -d windows

# Android (with device/emulator connected)
flutter run -d <device-id>

# Let Flutter choose device automatically
flutter run
```

### Hot Reload & Restart

When the app is running:
- Press **`r`** for hot reload (apply code changes without losing state)
- Press **`R`** for hot restart (restart app and reset state)
- Press **`q`** to quit

**Note**: First run may take longer as Flutter compiles assets and downloads dependencies.

## 🧪 Testing

### Run All Tests

```bash
# Run all unit tests
flutter test

# Run all tests with coverage
flutter test --coverage
```

### Run Specific Tests

```bash
# Run tests for a specific file
flutter test test/views/cart_screen_test.dart

# Run all tests in a directory
flutter test test/models/

# Run tests matching a pattern
flutter test --name "cart"
```

### Run Integration Tests

```bash
# Run integration tests (will prompt for device selection)
flutter test integration_test/app_test.dart

# Run on specific platform
flutter test integration_test/app_test.dart -d windows
flutter test integration_test/app_test.dart -d chrome
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage HTML (requires lcov)
# macOS/Linux:
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Windows (install Perl + lcov first):
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

### Test Statistics

- **Total Tests**: 210+
  - Unit Tests: 206+
  - Integration Tests: 4
- **Pass Rate**: 100%
- **Coverage**: High coverage on all critical paths
- **Test Categories**:
  - Model tests (Cart, Sandwich)
  - View tests (all 6 screens)
  - Repository tests (PricingRepository)
  - Widget tests (CommonAppBar, CartIndicator)
  - Integration tests (E2E user flows)

## 🏗️ Building for Production

### Clean and Prepare

```bash
# Clean previous builds
flutter clean
flutter pub get
```

### Build Commands

```bash
# Windows Desktop
flutter build windows --release
# Output: build/windows/x64/runner/Release/sandwich_shop.exe

# Android APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Android App Bundle (for Google Play)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab

# Web
flutter build web --release
# Output: build/web/

# Deploy to Firebase Hosting (after building web)
firebase deploy
# Live at: https://sandwich-shop-412f1.web.app

# iOS (macOS with Xcode only)
flutter build ipa --release
# Output: build/ios/ipa/
```

### Platform Requirements

- **Windows/Web**: Can be built on any platform
- **Android**: Requires Android SDK (can be built on any platform)
- **iOS**: Requires macOS with Xcode installed

## 🏛️ Architecture

### State Management

- **Provider Pattern**: Used for reactive Cart state management
- **ChangeNotifier**: Cart model extends ChangeNotifier for automatic UI updates
- **Consumer Widgets**: Screens listen to cart changes without manual subscriptions
- **Single Source of Truth**: Cart data managed centrally, accessed throughout app

### Database

- **SQLite (sqflite)**: Local database for order history persistence
- **Automatic Initialization**: Database created on first app launch
- **Cross-Platform**: sqflite_common_ffi for desktop platform support
- **Service Layer**: DatabaseService encapsulates all database operations

### Styling

- **Centralized AppStyles**: Consistent typography (heading1, heading2, normalText)
- **SharedPreferences**: Persistent user settings (font size customization)
- **Dynamic Theming**: Font sizes update across app in real-time
- **Responsive Design**: Adapts to different screen sizes

### Widgets

- **CommonAppBar**: Reusable app bar with logo, title, and cart indicator
- **CartIndicator**: Real-time cart badge showing item count
- **StyledButton**: Consistent button styling across screens
- **Modular Design**: Components are composable and reusable

### Repository Pattern

- **PricingRepository**: Encapsulates pricing business logic
- **Separation of Concerns**: Business logic isolated from UI
- **Testability**: Easy to unit test without UI dependencies

### Folder Organization

- **models/**: Data structures and business entities
- **views/**: UI screens, styling, and view-specific widgets
- **repositories/**: Business logic and calculations
- **services/**: External integrations (database, APIs)
- **widgets/**: Shared, reusable UI components

## 📝 Recent Changes

### Version 1.0 (December 2025)

- ✅ **Widget Refactoring**: Refactored app bar to CommonAppBar widget
- ✅ **Reusable Components**: Created CartIndicator widget for consistent cart display
- ✅ **Code Reduction**: Eliminated ~135 lines of duplicate code (89% reduction per screen)
- ✅ **Comprehensive Testing**: Added 210+ tests with 100% pass rate
- ✅ **Integration Tests**: Implemented 4 E2E tests covering critical user flows
- ✅ **Database Service**: Added SQLite integration for order history
- ✅ **Code Quality**: Improved maintainability and consistency across codebase
- ✅ **Documentation**: Enhanced README and added requirements documentation

### Previous Updates

- Order history screen with database persistence
- Profile management with input validation
- Settings screen with persistent font size
- Database integration using sqflite
- Provider state management implementation
- Comprehensive test suite

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Code Style

- Follow Flutter/Dart conventions and best practices
- Run `flutter analyze` before committing to catch linting issues
- Format code with `dart format .` for consistent style
- Follow existing architectural patterns (Provider, Repository)

### Testing Requirements

- Write unit tests for all new features
- Maintain >90% test coverage for critical code paths
- Ensure all existing tests pass: `flutter test`
- Add integration tests for new user flows
- Test on multiple platforms when possible

### Widget Development

- Create reusable components when appropriate
- Add shared widgets to `common_widgets.dart`
- Follow Provider pattern for state management
- Document widget APIs with clear comments
- Use const constructors where possible

### Commit Messages

Use clear, descriptive commit messages:

```
[type]: brief description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- test: Adding or updating tests
- refactor: Code refactoring
- style: Formatting changes
- chore: Maintenance tasks

Examples:
feat: add order cancellation feature
fix: resolve cart total calculation error
test: add unit tests for ProfileScreen
docs: update README with new features
```

### Pull Request Process

1. **Create Branch**: `git checkout -b feature/your-feature-name`
2. **Implement Changes**: Write code and tests
3. **Run Checks**:
   ```bash
   flutter analyze
   flutter test
   dart format .
   ```
4. **Commit Changes**: Use conventional commit format
5. **Push Branch**: `git push origin feature/your-feature-name`
6. **Create PR**: Include clear description and screenshots
7. **Address Reviews**: Respond to feedback promptly
8. **Merge**: Squash commits before merging to main

## ❓ Troubleshooting

### Database Initialization Errors

**Problem**: `databaseFactory not initialized`

**Solution**: For desktop integration tests, initialize sqflite_common_ffi:
```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // ... rest of test code
}
```

### Provider Context Errors

**Problem**: `Could not find the correct Provider<Cart> above this widget`

**Solution**: Ensure widget tree is wrapped with ChangeNotifierProvider:
```dart
ChangeNotifierProvider<Cart>(
  create: (_) => Cart(),
  child: MaterialApp(
    home: YourScreen(),
  ),
)
```

### Platform-Specific Build Issues

**Problem**: iOS build fails on Windows

**Solution**: iOS builds require macOS with Xcode. Use Windows, Android, or Web builds instead.

### Integration Test Failures

**Problem**: `Failed assertion: '_pendingFrame == null'`

**Solution**: Use proper pump/pumpAndSettle sequence in tests:
```dart
await tester.tap(find.text('Button'));
await tester.pump(); // Start async operation
await tester.pump(Duration(seconds: 2)); // Wait for timers
await tester.pumpAndSettle(); // Wait for animations
```

### Font Size Not Persisting

**Problem**: Font size resets on app restart

**Solution**: Ensure `AppStyles.loadFontSize()` is called in `main()` before running the app.

### Hot Reload Not Working

**Problem**: Changes not appearing after hot reload

**Solution**: Some changes require hot restart (press `R`) or full app restart:
- Changes to `main()`
- New dependencies in `pubspec.yaml`
- Native code changes
- Asset additions

## 📦 Dependencies

### Production Dependencies

- **flutter**: Flutter SDK
- **provider** `^6.1.5`: State management
- **sqflite** `^2.4.2`: Local SQLite database
- **shared_preferences** `^2.5.3`: Settings persistence
- **path** `^1.9.1`: File path utilities
- **cupertino_icons** `^1.0.0`: iOS-style icons

### Development Dependencies

- **flutter_test**: Unit testing framework
- **integration_test**: E2E testing framework
- **flutter_lints** `^2.0.0`: Code analysis and linting
- **sqflite_common_ffi** `^2.3.0`: Desktop database support for testing

### Deployment

- **Firebase Hosting**: Production web deployment
  - Live URL: [https://sandwich-shop-412f1.web.app](https://sandwich-shop-412f1.web.app)
  - Console: [Firebase Dashboard](https://console.firebase.google.com/project/sandwich-shop-412f1/overview)

## 💬 Support

### Get Help

- **Discord**: Join our [dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806) for real-time support
- **GitHub Issues**: Report bugs or request features at [GitHub Issues](https://github.com/manighahrmani/sandwich_shop/issues)
- **Documentation**: 
  - [Flutter Documentation](https://docs.flutter.dev)
  - [Dart Documentation](https://dart.dev/guides)
  - [Provider Documentation](https://pub.dev/packages/provider)

### When Asking for Help

Please provide:
- Clear description of the issue
- Error messages (full stack trace)
- Screenshots or screen recordings
- Steps to reproduce
- Your environment (OS, Flutter version: `flutter --version`)

## 📄 License

This project is part of a learning initiative. Please refer to the course materials for licensing information.

## 🙏 Credits

- **Flutter Team**: For the amazing framework
- **Community Contributors**: For packages and resources
- **Course Instructors**: For guidance and support

---

**Last Updated**: December 12, 2025  
**Version**: 1.0  
**Maintained by**: Sandwich Shop Development Team
