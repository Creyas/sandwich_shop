## LLM Prompt for Implementing Cart Modification Features in a Flutter Sandwich Shop App

I am building a Flutter app for a sandwich shop. The app has two main pages:
- **Order Screen:** Users select sandwiches and add them to their cart.
- **Cart Screen:** Users view the items in their cart and see the total price.

### Relevant Models and Repository

- **Sandwich (`lib/models/sandwich.dart`):**
  - Has `SandwichType`, `BreadType`, and a `bool isFootlong` for size.
  - Each sandwich has a `name` and an `image` getter for display.
- **Cart (`lib/models/cart.dart`):**
  - Stores a map of `Sandwich` to quantity.
  - Methods: `add(Sandwich, {quantity})`, `remove(Sandwich, {quantity})`, `clear()`, `getQuantity(Sandwich)`.
  - `totalPrice` is calculated using the `PricingRepository`.
  - If removing more than the current quantity, the item is removed entirely.
- **PricingRepository (`lib/repositories/pricing_repository.dart`):**
  - `calculatePrice({required int quantity, required bool isFootlong})` returns the price for a sandwich based on size and quantity.

### Current UI

- The cart page lists each sandwich, its size, bread type, quantity, and price.
- The total price is shown at the bottom.
- There is a "Back to Order" button.

---

## Features to Implement

### 1. Change Quantity of an Item

**Description:**  
Allow users to increase or decrease the quantity of a specific sandwich in their cart.

**Requirements:**  
- Each cart item should display "+" and "–" buttons to adjust quantity.
- Tapping "+" increases the quantity by 1.
- Tapping "–" decreases the quantity by 1.
- If the quantity is reduced below 1, the item should be removed from the cart.
- The total price should update automatically.
- The UI should update immediately to reflect changes.

**Edge Cases:**  
- If the user tries to decrease the quantity when it is 1, the item should be removed.
- Prevent negative quantities.

---

### 2. Remove an Item from the Cart

**Description:**  
Allow users to remove a sandwich from their cart entirely.

**Requirements:**  
- Each cart item should have a "Remove" button (e.g., a trash icon).
- Tapping "Remove" deletes the item from the cart.
- The total price updates accordingly.
- Show a snackbar or other feedback when an item is removed.

---

### 3. Edit Item Details (Optional)

**Description:**  
Allow users to edit details of a sandwich in their cart (e.g., change bread type, size, or sandwich type).

**Requirements:**  
- Each cart item should have an "Edit" button.
- Tapping "Edit" opens a dialog or navigates to a screen to modify sandwich options.
- After saving, the cart updates the item (or replaces it if the combination is new).
- The price and UI update accordingly.

---

### General UI and Behavior Requirements

- All changes should be reflected immediately in the UI.
- The cart's total price should always be accurate.
- The cart should handle empty states gracefully (e.g., show a message if the cart is empty).
- Provide user feedback (e.g., snackbar) for actions like removing or updating items.
- The UI should prevent adding more than a maximum allowed quantity (see `OrderScreen.maxQuantity`).

---

**Please provide Flutter code and UI suggestions to implement these features, using the provided models and repository.**

---

## Prompt: Refactor Duplicated Widgets into common_widgets.dart

**Context**: Our Flutter sandwich shop app currently has significant code duplication across multiple screens. The app bar with logo and cart indicator is implemented separately in each screen (OrderScreen, CartScreen, CheckoutScreen, ProfileScreen, SettingsScreen), leading to maintenance issues and inconsistencies.

**Task**: Create a new file `lib/views/common_widgets.dart` that contains reusable widgets, then refactor all existing screens to use these common widgets.

**Requirements**:

1. **Create `lib/views/common_widgets.dart`** containing:
   - `CommonAppBar` - A reusable app bar widget that includes:
     - Logo on the left (using `assets/images/logo.png`)
     - Custom title text (passed as parameter)
     - Cart indicator on the right (showing cart count with shopping cart icon)
     - Should use `Consumer<Cart>` for cart count
     - Should use `heading1` style from `app_styles.dart` for title
     - Should accept optional parameters for customization
   
   - `CartIndicator` - A standalone cart badge widget that:
     - Shows a shopping cart icon
     - Displays cart item count in a badge
     - Uses `Consumer<Cart>` to listen to cart changes
     - Can be reused in different contexts

2. **Refactor the following screens** to use the common widgets:
   - `lib/views/order_screen.dart`
   - `lib/views/cart_screen.dart`
   - `lib/views/checkout_screen.dart`
   - `lib/views/profile_screen.dart`
   - `lib/views/settings_screen.dart`

3. **Implementation Guidelines**:
   - Remove duplicate app bar code from each screen
   - Replace with `CommonAppBar` widget
   - Ensure all imports are correct
   - Maintain existing functionality (navigation, styling, etc.)
   - Keep the Provider pattern for cart management
   - Use named parameters for flexibility

4. **Expected Structure**:
   ```dart
   // Example structure (not complete code)
   class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
     final String title;
     // other parameters...
     
     @override
     Widget build(BuildContext context) {
       return AppBar(...);
     }
   }
   ```

5. **Update all test files** if necessary to account for the new widget structure.

6. **Ensure**:
   - No breaking changes to existing functionality
   - All screens display the same consistent app bar
   - Cart count updates correctly across all screens
   - Proper error handling and null safety

**Deliverables**:
1. New `lib/views/common_widgets.dart` file with reusable widgets
2. Updated screen files using the common widgets
3. List of all files modified
4. Confirmation that the app runs without errors

Please analyze the current codebase, identify all duplicated code, create the common widgets file, and refactor all screens accordingly.