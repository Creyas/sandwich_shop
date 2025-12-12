# Sandwich Shop Flutter App

## Project Overview

Welcome to the Sandwich Shop Flutter App! This application allows users to customize sandwiches, manage their shopping cart, and place orders for their favorite sandwiches. The app is built using Flutter and follows best practices for state management, testing, and code organization.

### Current Features
- **Sandwich Customization**: Choose sandwich type, size, bread, and quantity.
- **Shopping Cart**: Add, remove, and update sandwiches in the cart with real-time total price calculation.
- **Checkout Process**: Seamless checkout experience with order summary and confirmation.
- **Order History**: View past orders with details and status.
- **User Profile Management**: Update profile information and preferences.
- **Settings**: Customize app settings, including font size and notification preferences.
- **Responsive Design**: Optimized for various screen sizes and orientations.
- **Dark Mode Support**: Switch between light and dark themes.
- **Localization**: Support for multiple languages.

### Screens
- **OrderScreen**: Browse and select sandwiches.
- **CartScreen**: View and manage cart items.
- **CheckoutScreen**: Enter delivery details and payment information.
- **ProfileScreen**: View and edit user profile.
- **SettingsScreen**: Adjust app settings.
- **OrderHistoryScreen**: View past orders.

### Recent Refactoring
- Extracted common app bar and cart indicator widgets for reusability.
- Improved state management for cart and user settings.
- Enhanced code organization and folder structure.

### Database Integration
- Integrated sqflite for local database support.
- Used for persisting order history and user settings.

## Features

- Comprehensive sandwich customization options.
- Real-time cart updates and total price calculation.
- Secure checkout process with order confirmation.
- Persistent order history and user profile management.
- Responsive and adaptive UI for various devices.
- Provider-based state management for scalability.
- Integration with sqflite for local data persistence.

## Project Structure

```
lib/
├── main.dart
├── models/          # Data models (Cart, Sandwich)
├── views/           # All screens + common widgets
├── repositories/    # Pricing logic
├── services/        # Database service
└── widgets/         # Reusable UI components
test/                # Unit tests
integration_test/    # Integration tests
```

## Installation Instructions

To install and run the Sandwich Shop Flutter App, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/sandwich_shop_flutter.git
   cd sandwich_shop_flutter
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Set up the database** (for order history and user settings):
   - Follow the [sqflite installation guide](https://pub.dev/packages/sqflite) to set up the database.
4. **Run the app**:
   ```bash
   flutter run
   ```

### Platform Requirements
- Windows, macOS, or Linux for desktop support.
- Android or iOS device/emulator for mobile testing.

## Development Setup

For a smooth development experience, ensure you have the following set up:

- **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Included with Flutter SDK.
- **Editor**: Use any editor of your choice (VS Code, Android Studio, etc.) with Flutter and Dart plugins installed.
- **Database**: sqflite for local database support.

### Running on Different Platforms
To run the app on various platforms, use the following commands:

```bash
# Web
flutter run -d chrome

# Windows Desktop
flutter run -d windows

# Android (with device/emulator)
flutter run -d <device-id>
```

## Testing

The Sandwich Shop Flutter App includes comprehensive testing to ensure reliability and performance.

### Unit Tests
To run unit tests, use the following commands:

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/views/cart_screen_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Tests
To run integration tests, use the following commands:

```bash
# Run integration tests
flutter test integration_test/app_test.dart

# Choose platform when prompted
```

### Test Coverage
- Total test count: 210+ tests
- Test categories: models, views, repositories, widgets
- 100% pass rate

## Building for Production

To build the app for production, use the following commands:

```bash
# Windows
flutter build windows --release

# Android APK
flutter build apk --release

# Web
flutter build web --release

# iOS (macOS only)
flutter build ipa --release
```

## Architecture

The app is built using Flutter and follows best practices for state management, testing, and code organization.

- **State Management**: Provider pattern for Cart and User settings.
- **Database**: sqflite for order persistence and user settings.
- **Styling**: Centralized AppStyles with SharedPreferences for theme and font size.
- **Widgets**: Reusable CommonAppBar and CartIndicator widgets.
- **Repository Pattern**: PricingRepository for business logic and pricing calculations.

## Recent Changes/Changelog

- Refactored app bar to CommonAppBar widget for reusability.
- Created reusable CartIndicator widget to display cart item count.
- Eliminated ~135 lines of duplicate code in the app.
- Added comprehensive test suite with 210+ tests for models, views, and widgets.
- Implemented integration tests for end-to-end testing of the app.
- Added database service for order history and user settings persistence.

## Contributing Guidelines

We welcome contributions to the Sandwich Shop Flutter App! Please follow these guidelines:

- **Code Style**: Follow Flutter and Dart conventions for code style and formatting.
- **Testing Requirements**: Maintain >90% test coverage for new features and bug fixes.
- **Widget Reusability**: Create reusable and customizable widgets.
- **Commit Message Format**: Use clear and descriptive commit messages.
- **PR Review Process**: Submit pull requests for review and follow the review process.

## Troubleshooting

Common issues and solutions:

- **Database Initialization Errors**: Ensure sqflite is properly set up and initialized.
- **Provider Context Errors**: Check the widget tree for correct Provider usage.
- **Platform-Specific Build Issues**: Refer to platform-specific documentation for Flutter.
- **Integration Test Failures**: Ensure the app is in the correct state before running tests.

## Dependencies

Key dependencies used in the app:

- `provider`: State management solution for Flutter.
- `sqflite`: SQLite plugin for Flutter, used for local database.
- `shared_preferences`: Persistent storage for simple data.
- `flutter_test`: Flutter's testing framework for unit tests.
- `integration_test`: Flutter's integration testing framework.
- `sqflite_common_ffi`: SQLite plugin for Flutter, used for desktop support.

## Support

For support, please reach out through the following channels:

- **Discord**: Join our Discord server for real-time assistance and community support.
- **GitHub Issues**: Report bugs or issues on the GitHub repository.
- **Documentation**: Refer to the official Flutter and Dart documentation for development resources.

## License and Credits

This project is licensed under the MIT License. See the LICENSE file for details.

### Acknowledgments
- Special thanks to the Flutter community for their support and contributions.
- Icons made by Freepik from www.flaticon.com is licensed by CC 3.0 BY.

---

We hope you enjoy using the Sandwich Shop Flutter App! For any questions or feedback, feel free to reach out to the development team. Happy sandwich making! 🥪