# Cart Modification Feature Requirements

## 1. Feature Description and Purpose

The Cart Modification feature enables users of the Sandwich Shop Flutter app to manage the contents of their cart before checkout. Users can adjust the quantity of each sandwich or remove items. Editing sandwich details (such as bread type or size) is not supported on the cart page; users must add a new item from the order screen if they wish to change sandwich options. This feature aims to provide a flexible and user-friendly shopping experience, ensuring users can easily correct mistakes or change their order without starting over.

---

## 2. User Stories

### 2.1. Adjust Quantity

- **As a user**, I want to increase or decrease the quantity of a sandwich in my cart, so I can order the exact number I want.
- **As a user**, I want the cart to automatically remove an item if I decrease its quantity below 1, so my cart never contains items with zero or negative quantity.

### 2.2. Remove Item

- **As a user**, I want to remove a sandwich from my cart with a single action, so I can quickly update my order if I change my mind.

### 2.3. Feedback and UI Responsiveness

- **As a user**, I want the cart and total price to update immediately when I make changes, so I always see an accurate summary of my order.
- **As a user**, I want to receive feedback (such as a snackbar) when I remove or update an item, so I know my action was successful.
- **As a user**, I want to see a clear message if my cart is empty, so I know I need to add items before checking out.

---

## 3. Acceptance Criteria

### 3.1. Quantity Adjustment

- [ ] Each cart item displays "+" and "–" buttons for quantity adjustment.
- [ ] Tapping "+" increases the quantity by 1.
- [ ] Tapping "–" decreases the quantity by 1.
- [ ] If the quantity is reduced below 1, the item is removed from the cart.
- [ ] The total price updates automatically and accurately.
- [ ] The UI updates immediately to reflect changes.

### 3.2. Remove Item

- [ ] Each cart item has a "Remove" button (e.g., trash icon).
- [ ] Tapping "Remove" deletes the item from the cart.
- [ ] The total price updates accordingly.
- [ ] A snackbar or similar feedback is shown when an item is removed.

### 3.3. General UI and Behavior

- [ ] All changes are reflected immediately in the UI.
- [ ] The cart's total price is always accurate.
- [ ] The cart handles empty states gracefully (e.g., displays a message if empty).
- [ ] The UI prevents negative quantities.
- [ ] User feedback is provided for all cart modification actions.

---

## 4. Subtasks

1. Implement "+" and "–" quantity adjustment buttons for each cart item.
2. Implement logic to remove an item if its quantity is reduced below 1.
3. Add a "Remove" button for each cart item.
4. Ensure the total price and UI update immediately after any change.
5. Provide user feedback (snackbar) for remove and update actions.
6. Handle empty cart states with a clear message.

---

# Requirements Document: Update README.md with Current Project State

## 1. Overview

### 1.1 Project Name
Sandwich Shop App - README Documentation Update

### 1.2 Document Version
Version 1.0 - December 12, 2025

### 1.3 Purpose
This document outlines the requirements for updating the README.md file to accurately reflect the current state of the Sandwich Shop Flutter application, including all features, architecture changes, testing capabilities, and development guidelines.

### 1.4 Scope
This documentation effort focuses on creating comprehensive, accurate, and developer-friendly documentation that enables developers of all skill levels to understand, install, run, test, and contribute to the project.

---

## 2. Background and Problem Statement

### 2.1 Current State
The existing README.md file:
- References outdated branch numbers (branch 8)
- Lacks comprehensive feature documentation
- Missing testing instructions
- No build instructions for different platforms
- Doesn't document recent refactoring work
- Missing project structure information
- Limited troubleshooting guidance

### 2.2 Identified Problems
1. **Outdated Information**: References to old git branches and setup
2. **Incomplete Documentation**: Missing critical sections (testing, building, architecture)
3. **Limited Platform Support**: Only web browser instructions provided
4. **No Testing Guidance**: No information about 210+ test suite
5. **Missing Recent Changes**: Widget refactoring not documented
6. **Unclear Architecture**: No explanation of Provider pattern, database, or structure

### 2.3 Impact
- New developers struggle to set up and understand the project
- Testing procedures are not documented
- Platform-specific build instructions are missing
- Recent architectural improvements are not highlighted
- Contributing guidelines are absent

---

## 3. Goals and Objectives

### 3.1 Primary Goals
1. Create comprehensive, accurate documentation
2. Enable new developers to set up project independently
3. Document all features and capabilities
4. Provide clear testing and building instructions
5. Highlight recent architectural improvements

### 3.2 Secondary Goals
1. Establish documentation standards
2. Create troubleshooting guide
3. Document contributing guidelines
4. Improve project discoverability

### 3.3 Success Metrics
- [ ] New developers can set up project using only README
- [ ] All features are documented
- [ ] Testing instructions are complete
- [ ] Build instructions work for all platforms
- [ ] No outdated information remains
- [ ] Architecture is clearly explained

---

## 4. Detailed Requirements

### 4.1. Functional Requirements

#### FR-1: Project Overview Section
**Priority**: High  
**Description**: Update project description to reflect current capabilities.

**Content Requirements**:
- Comprehensive project description
- List all screens: OrderScreen, CartScreen, CheckoutScreen, ProfileScreen, SettingsScreen, OrderHistoryScreen
- Key functionalities: cart management, order processing, order history, settings
- Mention recent refactoring (CommonAppBar, CartIndicator)
- Database integration (sqflite)
- Provider state management

**Acceptance Criteria**:
- Overview is clear and concise
- All screens are listed
- Core features are mentioned
- Recent improvements are highlighted

#### FR-2: Features Section
**Priority**: High  
**Description**: Add comprehensive features list.

**Content Requirements**:
- Sandwich customization (type, size, bread, quantity, notes)
- Shopping cart with real-time updates
- Checkout and payment processing
- Order history with database persistence
- User profile management
- Settings (font size customization)
- Responsive UI with consistent styling
- Provider state management
- Cross-platform support (Windows, Web, Android, iOS)

**Format**: Bulleted list with brief descriptions

**Acceptance Criteria**:
- All features are listed
- Descriptions are clear
- No missing functionality

#### FR-3: Project Structure Section
**Priority**: High  
**Description**: Document folder structure.

**Content Requirements**:
```
sandwich_shop/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── cart.dart             # Shopping cart model
│   │   └── sandwich.dart         # Sandwich model
│   ├── views/                    # All screens
│   │   ├── order_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── order_history_screen.dart
│   │   ├── app_styles.dart       # Centralized styling
│   │   └── common_widgets.dart   # Reusable widgets
│   ├── repositories/             # Business logic
│   │   └── pricing_repository.dart
│   ├── services/                 # External services
│   │   └── database_service.dart
│   └── widgets/                  # Additional reusable widgets
├── test/                         # Unit tests
│   ├── models/
│   ├── views/
│   ├── repositories/
│   └── helpers/
├── integration_test/             # E2E tests
│   └── app_test.dart
└── assets/                       # Images and resources
    └── images/
```

**Acceptance Criteria**:
- Complete folder structure shown
- File purposes explained
- Easy to understand hierarchy

#### FR-4: Installation Instructions
**Priority**: High  
**Description**: Update installation steps.

**Changes Required**:
- Remove branch-specific references (branch 8)
- Update git clone to use main/master branch
- Add platform requirements note
- Mention desktop/web/mobile support

**New Instructions**:
```bash
git clone https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

**Acceptance Criteria**:
- No outdated branch references
- Clear clone instructions
- Works for new developers

#### FR-5: Development Setup Section
**Priority**: High  
**Description**: Add detailed setup instructions.

**Content Requirements**:
- Installing dependencies: `flutter pub get`
- Platform-specific setup:
  - Windows desktop support
  - Web browser setup
  - Android emulator/device
  - iOS (macOS only)
- Database initialization (automatic)
- Verifying installation

**Code Examples**:
```bash
# Install dependencies
flutter pub get

# Verify installation
flutter doctor

# Check available devices
flutter devices
```

**Acceptance Criteria**:
- All platforms covered
- Step-by-step instructions
- Verification steps included

#### FR-6: Running the App Section
**Priority**: High  
**Description**: Update with multiple platform options.

**Content Requirements**:
```bash
# Web (Chrome)
flutter run -d chrome

# Web (Edge)
flutter run -d edge

# Windows Desktop
flutter run -d windows

# Android (with device/emulator connected)
flutter run -d <device-id>

# Let Flutter choose device
flutter run
```

**Additional Notes**:
- First run may take longer (asset compilation)
- Hot reload available (press 'r' in terminal)
- Hot restart available (press 'R' in terminal)

**Acceptance Criteria**:
- All platforms documented
- Device selection explained
- Hot reload mentioned

#### FR-7: Testing Section
**Priority**: High  
**Description**: Add comprehensive testing documentation.

**Content Requirements**:

**Unit Tests**:
```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/views/cart_screen_test.dart

# Run specific test group
flutter test test/models/

# Run with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

**Integration Tests**:
```bash
# Run integration tests
flutter test integration_test/app_test.dart

# Run on specific platform
flutter test integration_test/app_test.dart -d windows
```

**Test Statistics**:
- Total tests: 210+
- Unit tests: 206+
- Integration tests: 4
- Pass rate: 100%
- Coverage: High (all critical paths)

**Test Categories**:
- Model tests (Cart, Sandwich)
- View tests (all screens)
- Repository tests (PricingRepository)
- Widget tests (CommonAppBar, CartIndicator)
- Integration tests (E2E flows)

**Acceptance Criteria**:
- All test commands documented
- Test statistics accurate
- Coverage instructions included

#### FR-8: Building for Production Section
**Priority**: Medium  
**Description**: Add build instructions for all platforms.

**Content Requirements**:
```bash
# Clean previous builds
flutter clean
flutter pub get

# Windows Desktop
flutter build windows --release

# Android APK
flutter build apk --release

# Android App Bundle (for Google Play)
flutter build appbundle --release

# Web
flutter build web --release

# iOS (macOS with Xcode only)
flutter build ipa --release
```

**Build Output Locations**:
- Windows: `build/windows/x64/runner/Release/sandwich_shop.exe`
- Android APK: `build/app/outputs/flutter-apk/app-release.apk`
- Android Bundle: `build/app/outputs/bundle/release/app-release.aab`
- Web: `build/web/`
- iOS: `build/ios/ipa/`

**Platform Notes**:
- iOS builds require macOS and Xcode
- Android builds require Android SDK
- Web builds work on all platforms

**Acceptance Criteria**:
- All platforms covered
- Build locations documented
- Platform requirements noted

#### FR-9: Architecture Section
**Priority**: High  
**Description**: Document application architecture.

**Content Requirements**:

**State Management**:
- Provider pattern for Cart state
- ChangeNotifier for reactive updates
- Consumer widgets for listening to changes
- Single source of truth for cart data

**Database**:
- sqflite for local storage
- Order history persistence
- Automatic database initialization
- sqflite_common_ffi for desktop support

**Styling**:
- Centralized AppStyles class
- SharedPreferences for user preferences
- Dynamic font sizing
- Consistent theming across app

**Widgets**:
- CommonAppBar: Reusable app bar component
- CartIndicator: Real-time cart badge
- StyledButton: Consistent button styling
- Modular, composable design

**Repository Pattern**:
- PricingRepository for business logic
- Separation of concerns
- Testable pricing calculations

**Folder Architecture**:
- models: Data structures
- views: UI screens and styles
- repositories: Business logic
- services: External integrations
- widgets: Reusable components

**Acceptance Criteria**:
- All patterns explained
- Clear examples provided
- Easy to understand

#### FR-10: Recent Changes/Changelog Section
**Priority**: Medium  
**Description**: Document major updates.

**Content Requirements**:
**Version 1.0 (December 2025)**:
- ✅ Refactored app bar to CommonAppBar widget
- ✅ Created reusable CartIndicator widget
- ✅ Eliminated ~135 lines of duplicate code (89% reduction per screen)
- ✅ Added comprehensive test suite (210+ tests, 100% pass rate)
- ✅ Implemented integration tests for E2E flows
- ✅ Added database service for order history
- ✅ Improved code maintainability and consistency
- ✅ Enhanced documentation

**Previous Updates**:
- Order history screen
- Profile management
- Settings screen
- Database integration
- Provider state management

**Acceptance Criteria**:
- Recent changes highlighted
- Dates included
- Impact mentioned

#### FR-11: Contributing Guidelines Section
**Priority**: Medium  
**Description**: Add contribution guidelines.

**Content Requirements**:

**Code Style**:
- Follow Flutter/Dart conventions
- Use `flutter analyze` before committing
- Format code with `dart format .`
- Follow existing patterns

**Testing Requirements**:
- Write tests for new features
- Maintain >90% coverage for critical paths
- Ensure all tests pass before PR
- Add integration tests for E2E flows

**Widget Development**:
- Create reusable components
- Use common_widgets.dart for shared widgets
- Follow Provider pattern for state
- Document widget APIs

**Commit Messages**:
- Use clear, descriptive messages
- Format: `[type]: description`
- Types: feat, fix, docs, test, refactor
- Example: `feat: add order cancellation feature`

**Pull Request Process**:
1. Create feature branch from main
2. Implement changes with tests
3. Run `flutter test` and `flutter analyze`
4. Submit PR with clear description
5. Address review comments
6. Squash commits before merge

**Acceptance Criteria**:
- Guidelines are clear
- Examples provided
- Process documented

#### FR-12: Troubleshooting Section
**Priority**: Medium  
**Description**: Add common issues and solutions.

**Content Requirements**:

**Database Initialization Errors**:
```
Problem: "databaseFactory not initialized"
Solution: For desktop testing, ensure sqflite_common_ffi is initialized:
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
```

**Provider Context Errors**:
```
Problem: "Provider not found in context"
Solution: Ensure widget tree is wrapped with ChangeNotifierProvider<Cart>
```

**Platform-Specific Build Issues**:
```
Problem: iOS build fails on Windows
Solution: iOS builds require macOS with Xcode. Use Windows/Android/Web builds instead.
```

**Integration Test Failures**:
```
Problem: "pending frame" assertion error
Solution: Use proper pump/pumpAndSettle sequence in tests
```

**Font Size Not Persisting**:
```
Problem: Font size resets on app restart
Solution: Ensure AppStyles.loadFontSize() is called in main()
```

**Acceptance Criteria**:
- Common issues covered
- Solutions are clear
- Code examples provided

#### FR-13: Dependencies Section
**Priority**: Low  
**Description**: List all dependencies with purposes.

**Content Requirements**:

**Production Dependencies**:
- `flutter` - Flutter SDK
- `provider: ^6.1.5` - State management
- `sqflite: ^2.4.2` - Local database
- `shared_preferences: ^2.5.3` - Settings persistence
- `path: ^1.9.1` - File path utilities
- `cupertino_icons: ^1.0.0` - iOS-style icons

**Development Dependencies**:
- `flutter_test` - Unit testing framework
- `integration_test` - E2E testing
- `flutter_lints: ^2.0.0` - Code analysis
- `sqflite_common_ffi: ^2.3.0` - Desktop database support

**Acceptance Criteria**:
- All dependencies listed
- Versions included
- Purposes explained

#### FR-14: Support Section
**Priority**: Low  
**Description**: Update support information.

**Content Requirements**:
- Keep existing Discord channel link
- Add GitHub Issues for bug reports
- Add documentation links (Flutter, Dart)
- Mention community resources

**Links**:
- Discord: https://discord.com/channels/760155974467059762/1370633732779933806
- GitHub Issues: https://github.com/manighahrmani/sandwich_shop/issues
- Flutter Docs: https://docs.flutter.dev
- Dart Docs: https://dart.dev/guides

**Acceptance Criteria**:
- All support channels listed
- Links are valid
- Clear instructions for help

#### FR-15: License and Credits Section
**Priority**: Low  
**Description**: Add license and credits (if applicable).

**Content Requirements**:
- License type (if applicable)
- Contributors list
- Third-party assets acknowledgments
- Course/tutorial credits (if applicable)

**Acceptance Criteria**:
- License is clear
- Contributors recognized
- Assets credited

---

## 5. Non-Functional Requirements

### NFR-1: Readability
- Clear, concise language
- Proper grammar and spelling
- Logical section flow
- Consistent formatting

### NFR-2: Accessibility
- Code blocks with syntax highlighting
- Clear headings hierarchy
- Table of contents (optional)
- Searchable keywords

### NFR-3: Maintainability
- Easy to update when project changes
- Modular sections
- Version tracking
- Date stamps on major updates

### NFR-4: Visual Appeal
- Proper Markdown formatting
- Consistent heading styles
- Code blocks properly formatted
- Optional emojis for visual interest (✅ 🚀 📱 🧪 ⚙️ 📖)

---

## 6. Technical Specifications

### 6.1 File Format
- **Format**: Markdown (.md)
- **Encoding**: UTF-8
- **Line Endings**: LF (Unix-style)
- **Max Line Length**: 100 characters (recommended)

### 6.2 Markdown Conventions

**Headings**:
```markdown
# H1 - Main Title
## H2 - Major Sections
### H3 - Subsections
#### H4 - Details
```

**Code Blocks**:
````markdown
```bash
# Bash commands
flutter run
```

```dart
// Dart code
void main() {}
````
````

The comprehensive requirements document has been added to [`requirements.md`](requirements.md ). This document provides:

1. **Complete specifications** for updating the README
2. **15 functional requirements** covering all sections
3. **Detailed content requirements** for each section
4. **Code examples** and formatting guidelines
5. **Acceptance criteria** for each section
6. **Timeline and milestones** for completion
7. **Testing and validation** procedures
8. **Maintenance plan** for keeping docs updated

This requirements document can now guide the README update process and ensure nothing is missed.