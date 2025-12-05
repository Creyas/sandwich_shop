# Feature Request: Cart Item Modification for Flutter Sandwich Shop App

## Context
I have a Flutter sandwich shop application with two main screens:
1. **Order Screen**: Users select sandwich type, size (footlong/six-inch), bread type, and quantity, then add items to cart
2. **Cart Screen**: Users view their cart items with quantities and total price

### Current Data Models & Architecture
- **Sandwich Model**: Contains `type` (enum: veggieDelight, chickenTeriyaki, tunaMelt, meatballMarinara), `isFootlong` (bool), and `breadType` (enum: white, wheat, wholemeal)
- **Cart Model**: Uses a `Map<Sandwich, int>` to store items and quantities
  - Methods: `add(Sandwich, quantity)`, `remove(Sandwich, quantity)`, `clear()`
  - Getters: `totalPrice`, `isEmpty`, `length`, `countOfItems`, `getQuantity(Sandwich)`
  - Note: The `remove()` method removes specified quantity; if quantity >= current quantity, removes the item entirely
- **PricingRepository**: Calculates prices based ONLY on quantity and size
  - Footlong: £11.00 per sandwich
  - Six-inch: £7.00 per sandwich
  - Price does NOT depend on sandwich type or bread type

### Current Cart Screen Implementation
The cart screen (`CartScreen` - a `StatefulWidget`) displays:
- Each cart item showing:
  - Sandwich name (e.g., "Veggie Delight")
  - Size and bread type (e.g., "Footlong on white bread")
  - Quantity and item subtotal (e.g., "Qty: 2 - £22.00")
- Total price at the bottom (sum of all item subtotals)
- "Back to Order" button (styled with `StyledButton`)
- The cart reference is passed from `OrderScreen` via constructor

## Feature Requirements

### 1. **Increase Item Quantity**
**Description**: Allow users to increment the quantity of an existing cart item by 1.

**UI Element**: Add a "+" icon button next to each cart item's quantity display.

**Behavior**:
- When the user taps the "+" button, call `cart.add(sandwich, quantity: 1)` to increment that item
- Immediately update the quantity display for that item (use cart's existing logic)
- Recalculate and update the item's subtotal using `PricingRepository.calculatePrice()`
- Recalculate and update the cart's total price (use `cart.totalPrice`)
- Use `setState()` to trigger UI rebuild
- No confirmation dialog needed

**Expected Result**: The quantity increases by 1, all prices update instantly, and the UI reflects the new state.

---

### 2. **Decrease Item Quantity**
**Description**: Allow users to decrement the quantity of an existing cart item by 1.

**UI Element**: Add a "-" icon button next to each cart item's quantity display.

**Behavior**:
- When the user taps the "-" button, call `cart.remove(sandwich, quantity: 1)`
- The cart's existing `remove()` method handles the logic:
  - If current quantity > 1: reduces quantity by 1
  - If current quantity = 1: removes the item entirely from the cart
- Immediately update displays using `setState()`
- Recalculate subtotal and total price
- No confirmation dialog needed when reducing quantity

**Expected Result**: The quantity decreases by 1, or the item is removed if quantity was 1. All prices update instantly.

---

### 3. **Remove Item Completely**
**Description**: Allow users to remove an item from the cart entirely, regardless of quantity.

**UI Element**: Add a delete/remove icon button (e.g., trash icon or delete icon) for each cart item.

**Behavior**:
- When user taps the delete button, show a confirmation dialog using `showDialog` and `AlertDialog`
- Dialog message: "Remove [Sandwich Name] from cart?" 
- Dialog buttons: "Cancel" and "Remove"
- If user confirms: 
  - Get the current quantity using `cart.getQuantity(sandwich)`
  - Call `cart.remove(sandwich, quantity: currentQuantity)` to remove the item entirely
- If user cancels: close dialog, no action
- After removal, use `setState()` to update UI
- Recalculate total price
- If cart becomes empty (`cart.isEmpty`), display appropriate empty cart state

**Expected Result**: After confirmation, the item is completely removed, UI updates to show remaining items, and total price recalculates.

---

### 4. **Clear Entire Cart**
**Description**: Allow users to remove all items from the cart at once.

**UI Element**: Add a "Clear Cart" button at the bottom of the cart screen (styled distinctly, perhaps with a warning/error color like `Colors.red`).

**Behavior**:
- When user taps "Clear Cart", show a confirmation dialog
- Dialog message: "Are you sure you want to clear your entire cart?"
- Dialog buttons: "Cancel" and "Clear All"
- If user confirms: call `cart.clear()` method
- If user cancels: close dialog, no action
- After clearing, use `setState()` to show empty cart state
- Display empty cart message with navigation back to order screen

**Expected Result**: After confirmation, all cart items are removed, empty state is displayed.

---

### 5. **Empty Cart State**
**Description**: Display a user-friendly message when the cart has no items.

**UI Element**: A centered message displayed when `cart.isEmpty` is true.

**Behavior**:
- When `cart.isEmpty` is true, hide the cart items list and total price section
- Display centered message: "Your cart is empty"
- Include an icon (e.g., `Icons.shopping_cart` or similar)
- Show a button: "Start Shopping" or "Back to Order" that calls `Navigator.pop(context)` to return to order screen
- This state appears when:
  - User opens cart before adding any items
  - User clears the entire cart
  - User removes the last remaining item

**Expected Result**: Users see a clear empty state with guidance to add items, with easy navigation back to order screen.

---

## Technical Implementation Notes
- **Cart Operations**: Use existing `Cart` class methods (`add()`, `remove()`, `clear()`, `getQuantity()`)
- **State Management**: Use `setState()` to rebuild UI after any cart modification (the cart screen is already a `StatefulWidget`)
- **Cart Reference**: Use `widget.cart` to access the cart passed from `OrderScreen` (already implemented this way)
- **Price Calculation**: Use `PricingRepository().calculatePrice(quantity: quantity, isFootlong: sandwich.isFootlong)` for item subtotals
- **Dialogs**: Use `showDialog()` with `AlertDialog` for confirmations
- **Price Formatting**: Continue using `.toStringAsFixed(2)` for all price displays
- **Layout**: The cart items are currently displayed in a `SingleChildScrollView` with a `Column`
- **Styling**: Use existing styles from `app_styles.dart` (heading1, heading2, normalText) and `StyledButton` widget

## Additional Context
- The app uses `maxQuantity: 5` constraint on the order screen (set in `main.dart`)
- The cart screen receives the cart via constructor: `CartScreen({required this.cart})`
- Cart item iteration currently uses: `for (MapEntry<Sandwich, int> entry in widget.cart.items.entries)`
- The order screen shows a snackbar when items are added to cart

## Desired Code Quality
- Follow the existing code style and patterns in the app
- Add private methods with descriptive names (e.g., `_increaseQuantity()`, `_showRemoveDialog()`)
- Keep the UI consistent with existing design patterns
- Handle edge cases gracefully (empty cart, last item removal, etc.)
- Ensure the cart state persists correctly when navigating between screens
- Add comments for complex logic

## Deliverable
Please provide:
1. Updated `cart_screen.dart` with all modification features implemented
2. Explanation of any design decisions made
3. Notes on how the features integrate with the existing cart model methods

# Prompt: Create Sign In/Sign Up Authentication Screens for Sandwich Shop App

Create a complete authentication system for the Sandwich Shop Flutter app with the following requirements:

## Files to Create

1. `lib/views/auth_screen.dart` - Main authentication screen with sign in and sign up tabs
2. `lib/models/user.dart` - User model to store user information
3. `lib/services/auth_service.dart` - Authentication service for handling sign in/sign up logic
4. `test/views/auth_screen_test.dart` - Comprehensive tests for the auth screen

## Design Requirements

### Visual Design

- Use the existing app styles from `app_styles.dart` (heading1, heading2, normalText)
- Include the sandwich shop logo at the top (use `assets/images/logo.png`)
- Use a TabBar with two tabs: "Sign In" and "Sign Up"
- Maintain consistency with the existing app's color scheme (orange accent colors)
- Make it visually appealing with proper spacing and padding

### Sign In Tab Features

- Email input field with email validation
- Password input field with visibility toggle
- "Remember Me" checkbox
- "Sign In" button (disabled until valid input)
- "Forgot Password?" text button
- Error message display for invalid credentials
- Loading indicator during authentication

### Sign Up Tab Features

- Full name input field
- Email input field with email validation
- Password input field with:
  - Visibility toggle
  - Minimum 8 characters requirement
  - Must contain at least one uppercase letter, one number
- Confirm password field (must match password)
- Phone number input field (optional)
- "Sign Up" button (disabled until all validations pass)
- Terms and conditions checkbox with clickable link
- Error message display
- Loading indicator during registration

## Functionality Requirements

- Form validation with real-time feedback
- Show/hide password functionality
- Proper keyboard handling (dismiss on tap outside)
- Navigation to OrderScreen after successful authentication
- Store user session (use shared_preferences or similar)
- Handle authentication errors gracefully
- Display success/error SnackBars

## User Model (`lib/models/user.dart`)

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  
  // Include necessary methods: toJson, fromJson, copyWith
}