# Requirements Document: Cart Item Modification Feature

## 1. Feature Overview

### 1.1 Feature Description
The Cart Item Modification feature enables users to manage items in their shopping cart after they have been added from the order screen. This feature provides essential cart management capabilities including adjusting quantities, removing individual items, and clearing the entire cart.

### 1.2 Purpose
- **Flexibility**: Allow users to modify their order without navigating back to the order screen
- **Error Correction**: Enable users to fix mistakes (wrong quantity, unwanted items)
- **User Control**: Provide intuitive cart management that improves the shopping experience
- **Reduced Friction**: Allow quick adjustments to orders before checkout/submission

### 1.3 Scope
This feature applies only to the Cart Screen (`cart_screen.dart`) and utilizes existing models and repositories without requiring backend changes. All modifications are reflected immediately in the UI and persist while the cart object remains in memory.

---

## 2. User Stories

### 2.1 As a customer, I want to increase the quantity of an item in my cart
**So that** I can order more of the same sandwich without returning to the order screen and going through the full selection process again.

**Acceptance Criteria**:
- A "+" button is visible next to each cart item
- Clicking "+" increases the quantity by 1 immediately
- The item's subtotal updates to reflect the new quantity
- The cart's total price updates automatically
- No page reload or navigation is required
- The change happens without confirmation dialog

---

### 2.2 As a customer, I want to decrease the quantity of an item in my cart
**So that** I can reduce my order if I added too many of a particular sandwich.

**Acceptance Criteria**:
- A "-" button is visible next to each cart item
- Clicking "-" decreases the quantity by 1 when quantity > 1
- When quantity is 1, clicking "-" removes the item entirely from cart
- The item's subtotal updates to reflect the new quantity (or item disappears if removed)
- The cart's total price updates automatically
- No confirmation dialog is shown for quantity reduction
- If the last item is removed, the empty cart state is displayed

---

### 2.3 As a customer, I want to remove an item completely from my cart
**So that** I can delete items I no longer want without having to decrement the quantity multiple times.

**Acceptance Criteria**:
- A delete/trash icon button is visible for each cart item
- Clicking the delete button shows a confirmation dialog
- The dialog displays the sandwich name and asks for confirmation
- The dialog provides "Cancel" and "Remove" options
- Clicking "Cancel" closes the dialog without changes
- Clicking "Remove" deletes the entire item regardless of quantity
- The cart updates immediately after confirmation
- The total price recalculates
- If this was the last item, the empty cart state is displayed

---

### 2.4 As a customer, I want to clear my entire cart at once
**So that** I can start over with a fresh order when I change my mind about my selections.

**Acceptance Criteria**:
- A "Clear Cart" button is prominently displayed (styled with warning color)
- The button is only visible when the cart contains items
- Clicking "Clear Cart" shows a confirmation dialog
- The dialog warns about removing all items
- The dialog provides "Cancel" and "Clear All" options
- Clicking "Cancel" closes the dialog without changes
- Clicking "Clear All" removes all items from the cart
- The empty cart state is displayed after clearing
- The total price shows £0.00 or is hidden

---

### 2.5 As a customer, I want to see a helpful message when my cart is empty
**So that** I understand the cart state and know how to proceed with adding items.

**Acceptance Criteria**:
- When the cart is empty, a centered message states "Your cart is empty"
- An appropriate icon (shopping cart) is displayed
- A button labeled "Start Shopping" or "Back to Order" is visible
- Clicking the button navigates back to the order screen
- This state appears when:
  - The cart has never had items added
  - All items have been removed
  - The cart has been cleared
- No cart items, subtotals, or total price are shown in this state

---

### 2.6 As a customer, I want all price calculations to update automatically
**So that** I always see accurate pricing information without manual refreshes.

**Acceptance Criteria**:
- Any quantity change immediately recalculates the item's subtotal
- Any cart modification immediately recalculates the total price
- All prices are formatted with 2 decimal places (e.g., £22.00)
- Price calculations use the PricingRepository (£11.00 for footlong, £7.00 for six-inch)
- No manual refresh or page reload is required

---

## 3. Functional Requirements

### 3.1 Increase Quantity Feature
**FR-1.1**: The system shall display a "+" button for each cart item
**FR-1.2**: The system shall call `cart.add(sandwich, quantity: 1)` when "+" is clicked
**FR-1.3**: The system shall update the UI using `setState()` after the addition
**FR-1.4**: The system shall recalculate the item subtotal using `PricingRepository.calculatePrice()`
**FR-1.5**: The system shall update the total cart price using `cart.totalPrice`

### 3.2 Decrease Quantity Feature
**FR-2.1**: The system shall display a "-" button for each cart item
**FR-2.2**: The system shall call `cart.remove(sandwich, quantity: 1)` when "-" is clicked
**FR-2.3**: The system shall remove the item completely if the quantity is 1
**FR-2.4**: The system shall update the UI using `setState()` after the removal
**FR-2.5**: The system shall recalculate prices after quantity changes
**FR-2.6**: The system shall display the empty cart state if the last item is removed

### 3.3 Remove Item Feature
**FR-3.1**: The system shall display a delete icon button for each cart item
**FR-3.2**: The system shall show a confirmation `AlertDialog` when delete is clicked
**FR-3.3**: The dialog shall display "Remove [Sandwich Name] from cart?"
**FR-3.4**: The dialog shall provide "Cancel" and "Remove" buttons
**FR-3.5**: On confirmation, the system shall get the quantity using `cart.getQuantity(sandwich)`
**FR-3.6**: The system shall call `cart.remove(sandwich, quantity: currentQuantity)` to remove completely
**FR-3.7**: The system shall update the UI and recalculate prices after removal
**FR-3.8**: The system shall display the empty cart state if the cart becomes empty

### 3.4 Clear Cart Feature
**FR-4.1**: The system shall display a "Clear Cart" button styled with a warning color
**FR-4.2**: The button shall only be visible when `cart.isEmpty` is false
**FR-4.3**: The system shall show a confirmation `AlertDialog` when "Clear Cart" is clicked
**FR-4.4**: The dialog shall display "Are you sure you want to clear your entire cart?"
**FR-4.5**: The dialog shall provide "Cancel" and "Clear All" buttons
**FR-4.6**: On confirmation, the system shall call `cart.clear()`
**FR-4.7**: The system shall display the empty cart state after clearing

### 3.5 Empty Cart State
**FR-5.1**: The system shall detect when `cart.isEmpty` is true
**FR-5.2**: The system shall hide the cart items list when empty
**FR-5.3**: The system shall hide or show £0.00 for the total price when empty
**FR-5.4**: The system shall display "Your cart is empty" message
**FR-5.5**: The system shall display a shopping cart icon
**FR-5.6**: The system shall provide a button to navigate back to the order screen using `Navigator.pop(context)`

---

## 4. Non-Functional Requirements

### 4.1 Performance
**NFR-1.1**: Cart modifications shall reflect in the UI within 100ms
**NFR-1.2**: Price recalculations shall complete within 50ms
**NFR-1.3**: Dialog animations shall be smooth and not cause UI lag

### 4.2 Usability
**NFR-2.1**: All interactive buttons shall have appropriate touch targets (minimum 48x48 pixels)
**NFR-2.2**: Button icons shall be clear and universally recognizable
**NFR-2.3**: Confirmation dialogs shall be easily readable and unambiguous
**NFR-2.4**: The UI shall maintain consistency with existing app design patterns

### 4.3 Reliability
**NFR-3.1**: Cart state shall persist correctly when navigating between screens
**NFR-3.2**: All edge cases (empty cart, single item, multiple items) shall be handled gracefully
**NFR-3.3**: No crashes or exceptions shall occur during cart operations

### 4.4 Maintainability
**NFR-4.1**: Code shall follow existing project conventions and style
**NFR-4.2**: Private methods shall have descriptive names (e.g., `_increaseQuantity()`, `_showRemoveDialog()`)
**NFR-4.3**: Complex logic shall include explanatory comments
**NFR-4.4**: The implementation shall integrate seamlessly with existing Cart model methods

---

## 5. Acceptance Criteria

### 5.1 Feature Completion Criteria
The Cart Item Modification feature is considered complete when ALL of the following conditions are met:

#### 5.1.1 Increase Quantity
- [ ] "+" button is visible for each cart item
- [ ] Tapping "+" increases quantity by 1
- [ ] Item subtotal updates correctly
- [ ] Cart total updates correctly
- [ ] UI updates without lag or reload
- [ ] Multiple consecutive increases work correctly

#### 5.1.2 Decrease Quantity
- [ ] "-" button is visible for each cart item
- [ ] Tapping "-" decreases quantity by 1 when qty > 1
- [ ] Tapping "-" removes item when qty = 1
- [ ] Item subtotal updates correctly
- [ ] Cart total updates correctly
- [ ] Empty cart state appears when last item is removed
- [ ] Multiple consecutive decreases work correctly

#### 5.1.3 Remove Item
- [ ] Delete icon button is visible for each cart item
- [ ] Tapping delete shows confirmation dialog
- [ ] Dialog displays correct sandwich name
- [ ] "Cancel" button closes dialog without changes
- [ ] "Remove" button deletes the entire item
- [ ] Cart updates immediately after removal
- [ ] Empty cart state appears if cart becomes empty
- [ ] Multiple items can be removed sequentially

#### 5.1.4 Clear Cart
- [ ] "Clear Cart" button is visible when cart has items
- [ ] "Clear Cart" button is styled with warning color
- [ ] Tapping "Clear Cart" shows confirmation dialog
- [ ] "Cancel" button closes dialog without changes
- [ ] "Clear All" button removes all items
- [ ] Empty cart state appears after clearing
- [ ] Button is hidden or disabled when cart is empty

#### 5.1.5 Empty Cart State
- [ ] "Your cart is empty" message displays when cart is empty
- [ ] Shopping cart icon is visible
- [ ] Navigation button is present and labeled clearly
- [ ] Tapping navigation button returns to order screen
- [ ] No cart items or prices are shown
- [ ] State appears in all empty cart scenarios

#### 5.1.6 Price Calculations
- [ ] All item subtotals calculate correctly (quantity × price per size)
- [ ] Total price sums all item subtotals correctly
- [ ] Prices format with 2 decimal places (£X.XX)
- [ ] Footlong items use £11.00 per sandwich
- [ ] Six-inch items use £7.00 per sandwich
- [ ] Prices update immediately with any cart change

#### 5.1.7 Integration & State Management
- [ ] Cart state persists when navigating to order screen and back
- [ ] All operations use existing Cart model methods correctly
- [ ] `setState()` is called appropriately for UI updates
- [ ] `widget.cart` reference is used correctly
- [ ] No new cart instances are created unintentionally

#### 5.1.8 Code Quality
- [ ] Code follows existing project style and conventions
- [ ] Private methods have descriptive names
- [ ] Complex logic includes helpful comments
- [ ] No compiler warnings or errors
- [ ] Code is readable and maintainable
- [ ] Consistent with existing cart_screen.dart patterns

---

## 6. Testing Requirements

### 6.1 Manual Testing Scenarios

#### Test Case 1: Increase Quantity
1. Add 1 Footlong Veggie Delight to cart
2. Navigate to cart screen
3. Verify quantity shows as 1, subtotal shows £11.00
4. Tap "+" button
5. Verify quantity shows as 2, subtotal shows £22.00
6. Verify total price shows £22.00

#### Test Case 2: Decrease Quantity (Multiple Items)
1. Add 3 Six-inch Chicken Teriyaki to cart
2. Navigate to cart screen
3. Verify quantity shows as 3, subtotal shows £21.00
4. Tap "-" button
5. Verify quantity shows as 2, subtotal shows £14.00
6. Verify total price shows £14.00

#### Test Case 3: Decrease Quantity to Zero (Item Removal)
1. Add 1 Footlong Tuna Melt to cart
2. Navigate to cart screen
3. Verify item is displayed
4. Tap "-" button
5. Verify item is removed from cart
6. Verify empty cart state is displayed

#### Test Case 4: Remove Item with Confirmation
1. Add 5 Footlong Meatball Marinara to cart
2. Navigate to cart screen
3. Tap delete icon
4. Verify confirmation dialog appears with sandwich name
5. Tap "Cancel"
6. Verify item remains in cart
7. Tap delete icon again
8. Tap "Remove"
9. Verify item is removed completely
10. Verify empty cart state is displayed

#### Test Case 5: Clear Multiple Items
1. Add Footlong Veggie Delight (qty: 2) to cart
2. Add Six-inch Chicken Teriyaki (qty: 1) to cart
3. Navigate to cart screen
4. Verify both items are displayed
5. Tap "Clear Cart" button
6. Verify confirmation dialog appears
7. Tap "Cancel"
8. Verify items remain in cart
9. Tap "Clear Cart" again
10. Tap "Clear All"
11. Verify all items are removed
12. Verify empty cart state is displayed

#### Test Case 6: Empty Cart Navigation
1. Navigate to cart screen with empty cart
2. Verify empty cart message is displayed
3. Verify navigation button is present
4. Tap navigation button
5. Verify user returns to order screen

#### Test Case 7: Cart State Persistence
1. Add items to cart
2. Navigate to cart screen
3. Increase quantity of one item
4. Navigate back to order screen
5. Navigate to cart screen again
6. Verify modified quantity persists

#### Test Case 8: Mixed Operations
1. Add Footlong Veggie Delight (qty: 2) to cart
2. Add Six-inch Tuna Melt (qty: 3) to cart
3. Navigate to cart screen
4. Increase Footlong Veggie Delight to qty: 3
5. Decrease Six-inch Tuna Melt to qty: 2
6. Verify total price: (3 × £11.00) + (2 × £7.00) = £47.00
7. Remove Six-inch Tuna Melt completely
8. Verify total price: 3 × £11.00 = £33.00
9. Clear entire cart
10. Verify empty cart state

---

## 7. Technical Specifications

### 7.1 Affected Files
- **Primary**: `lib/views/cart_screen.dart` (modifications required)
- **Dependencies**: 
  - `lib/models/cart.dart` (existing, no changes)
  - `lib/models/sandwich.dart` (existing, no changes)
  - `lib/repositories/pricing_repository.dart` (existing, no changes)
  - `lib/views/app_styles.dart` (existing, for styling)

### 7.2 New Methods Required in cart_screen.dart
- `_increaseQuantity(Sandwich sandwich)` - Handle quantity increase
- `_decreaseQuantity(Sandwich sandwich)` - Handle quantity decrease
- `_showRemoveItemDialog(Sandwich sandwich)` - Display remove confirmation
- `_removeItem(Sandwich sandwich)` - Remove item after confirmation
- `_showClearCartDialog()` - Display clear cart confirmation
- `_clearCart()` - Clear cart after confirmation
- `_buildEmptyCartState()` - Build empty cart UI widget
- `_buildCartItemsList()` - Build cart items list widget (refactor existing)

### 7.3 UI Component Structure

# Requirements Document: Authentication System for Sandwich Shop App

## 1. Feature Description and Purpose

### Overview
Implement a comprehensive authentication system for the Sandwich Shop Flutter application that allows users to create accounts, sign in, and manage their sessions. This feature will enable personalized user experiences, order history tracking, and secure access to the application.

### Purpose
- **User Account Management**: Enable users to create and manage their personal accounts
- **Security**: Protect user data and ensure secure access to the application
- **Personalization**: Allow the app to provide personalized experiences based on user identity
- **Session Management**: Maintain user sessions across app launches
- **Future Scalability**: Provide foundation for features like order history, saved preferences, and loyalty programs

### Business Value
- Increased user engagement through personalized experiences
- Ability to track and analyze user behavior
- Foundation for implementing advanced features (order history, favorites, rewards)
- Enhanced customer relationship management

---

## 2. User Stories

### User Story 1: New User Registration
**As a** new customer  
**I want to** create an account with my email and password  
**So that** I can save my information and track my orders

**Acceptance Criteria:**
- User can access the Sign Up tab from the authentication screen
- User can enter their full name, email, password, and optional phone number
- Password must meet security requirements (8+ characters, 1 uppercase, 1 number)
- User must confirm their password by entering it twice
- User must accept terms and conditions before signing up
- System validates email format and shows error for invalid entries
- System shows error if passwords don't match
- Upon successful registration, user is automatically signed in and navigated to OrderScreen
- Success message is displayed after registration
- User information is stored locally for session management

### User Story 2: Returning User Sign In
**As a** returning customer  
**I want to** sign in with my email and password  
**So that** I can access my account and continue ordering

**Acceptance Criteria:**
- User can access the Sign In tab from the authentication screen
- User can enter their email and password
- Password field has toggle to show/hide password
- "Remember Me" option persists login credentials (optional implementation)
- Sign In button is disabled until valid email and password are entered
- System validates credentials and shows error for incorrect entries
- Upon successful sign in, user is navigated to OrderScreen
- User session is stored locally
- Error messages are clear and helpful (e.g., "Invalid email or password")

### User Story 3: Password Reset
**As a** user who forgot my password  
**I want to** reset my password using my email  
**So that** I can regain access to my account

**Acceptance Criteria:**
- User can tap "Forgot Password?" link from Sign In tab
- User can enter their email address
- System validates email format
- System displays confirmation message (mock implementation)
- User receives instructions for password reset (simulated)
- Clear messaging about next steps

### User Story 4: Session Persistence
**As a** signed-in user  
**I want to** remain signed in when I close and reopen the app  
**So that** I don't have to sign in every time

**Acceptance Criteria:**
- User session is saved locally using shared_preferences
- App checks for existing session on launch
- If valid session exists, user goes directly to OrderScreen
- If no session exists, user sees AuthScreen
- User can sign out from within the app
- Session is cleared upon sign out

### User Story 5: Form Validation Feedback
**As a** user filling out authentication forms  
**I want to** receive real-time feedback on my input  
**So that** I can correct errors before submitting

**Acceptance Criteria:**
- Email field shows error for invalid format
- Password field shows requirements and validation status
- Confirm password field shows match/mismatch status
- Required fields show error when left empty and user moves to next field
- Form submit button is disabled until all validations pass
- Validation messages are clear and actionable
- Visual indicators (colors, icons) help identify field status

### User Story 6: Secure Password Entry
**As a** user entering my password  
**I want to** toggle password visibility  
**So that** I can verify I've typed it correctly

**Acceptance Criteria:**
- Password field shows masked characters by default
- Eye icon button allows toggling between masked and visible text
- Icon changes to indicate current state (eye/eye-slash)
- Toggle works for both password and confirm password fields
- Password remains secure when keyboard is visible

### User Story 7: Logout Functionality
**As a** signed-in user  
**I want to** sign out of my account  
**So that** I can protect my privacy or switch accounts

**Acceptance Criteria:**
- Logout option is available from OrderScreen (menu or button)
- User is prompted to confirm logout action
- Upon logout, session data is cleared
- User is navigated back to AuthScreen
- Cart data handling is considered (optional: save or clear)

---

## 3. Acceptance Criteria

### 3.1 UI/UX Criteria

#### Visual Consistency
- [ ] Authentication screens use existing app styles (heading1, heading2, normalText)
- [ ] Color scheme matches existing app design (orange accents)
- [ ] Logo is displayed prominently at the top of AuthScreen
- [ ] Spacing and padding are consistent with other app screens
- [ ] Layout is responsive and works on different screen sizes
- [ ] Keyboard handling doesn't obscure input fields

#### Navigation and Flow
- [ ] TabBar allows smooth switching between Sign In and Sign Up
- [ ] Tab transitions are animated smoothly
- [ ] Back button navigation works correctly
- [ ] Navigation to OrderScreen occurs after successful authentication
- [ ] Keyboard dismisses when tapping outside input fields
- [ ] Focus moves logically between fields (tab order)

#### Feedback and Messaging
- [ ] Loading indicators display during authentication operations
- [ ] Success messages appear via SnackBar
- [ ] Error messages are displayed clearly and helpfully
- [ ] All user actions receive immediate visual feedback
- [ ] Empty state messaging is clear and actionable

### 3.2 Functional Criteria

#### Sign In Functionality
- [ ] Email field validates email format
- [ ] Password field accepts input and masks characters
- [ ] Password visibility toggle works correctly
- [ ] "Remember Me" checkbox persists user preference
- [ ] Sign In button is disabled with invalid input
- [ ] Sign In button is enabled with valid input
- [ ] Successful sign in navigates to OrderScreen
- [ ] Failed sign in displays error message
- [ ] "Forgot Password?" link triggers password reset flow

#### Sign Up Functionality
- [ ] Full name field accepts text input
- [ ] Email field validates format
- [ ] Password field enforces minimum 8 characters
- [ ] Password field requires at least one uppercase letter
- [ ] Password field requires at least one number
- [ ] Password visibility toggle works
- [ ] Confirm password field validates match with password
- [ ] Phone number field is optional
- [ ] Terms and conditions checkbox is required
- [ ] Terms link is tappable (can open dialog or external link)
- [ ] Sign Up button is disabled until all validations pass
- [ ] Successful registration creates user and navigates to OrderScreen
- [ ] Duplicate email shows appropriate error

#### Validation Criteria
- [ ] Email validation uses proper regex pattern
- [ ] Password validation checks length, uppercase, and number requirements
- [ ] Confirm password validation ensures exact match
- [ ] Phone number validation (if implemented) checks format
- [ ] Real-time validation provides immediate feedback
- [ ] Validation errors are displayed near relevant fields
- [ ] All required fields are enforced

#### Session Management
- [ ] User session is saved to local storage on sign in/up
- [ ] App checks for existing session on launch
- [ ] Valid session bypasses AuthScreen
- [ ] Session data includes user ID, name, email
- [ ] Sign out clears all session data
- [ ] Session persists across app restarts

### 3.3 Data Model Criteria

#### User Model
- [ ] User class includes: id, name, email, phoneNumber (optional), createdAt
- [ ] User class has toJson() method for serialization
- [ ] User class has fromJson() factory constructor
- [ ] User class has copyWith() method for updates
- [ ] All required fields are non-nullable
- [ ] Optional fields are properly typed as nullable

#### Auth Service
- [ ] signIn() method accepts email and password
- [ ] signIn() returns User object on success, null on failure
- [ ] signUp() method accepts name, email, password, phone
- [ ] signUp() returns User object on success, null on failure
- [ ] getCurrentUser() retrieves stored user session
- [ ] signOut() clears stored session
- [ ] resetPassword() handles password reset flow (mock)
- [ ] All methods are properly async with Future return types
- [ ] Error handling is implemented for all methods
- [ ] Service uses shared_preferences for local storage

### 3.4 Integration Criteria

#### Main App Integration
- [ ] main.dart checks for existing session on app start
- [ ] AuthScreen displays if no session exists
- [ ] OrderScreen displays if valid session exists
- [ ] User data is accessible throughout the app
- [ ] Navigation flow works seamlessly

#### Logout Integration
- [ ] Logout option exists in OrderScreen or user menu
- [ ] Logout action is confirmed with user
- [ ] Logout clears session and returns to AuthScreen
- [ ] Cart state handling is considered

### 3.5 Testing Criteria

#### Widget Tests (auth_screen_test.dart)
- [ ] Test renders Sign In tab correctly
- [ ] Test renders Sign Up tab correctly
- [ ] Test tab switching functionality
- [ ] Test email validation for both tabs
- [ ] Test password validation (length, uppercase, number)
- [ ] Test confirm password validation
- [ ] Test password visibility toggle
- [ ] Test button enabled/disabled states
- [ ] Test form submission with valid data
- [ ] Test form submission with invalid data
- [ ] Test error message display
- [ ] Test loading state display
- [ ] Test navigation after successful authentication
- [ ] Test "Remember Me" checkbox (Sign In)
- [ ] Test Terms checkbox (Sign Up)
- [ ] Test "Forgot Password?" action

#### Unit Tests (auth_service_test.dart)
- [ ] Test signIn with valid credentials
- [ ] Test signIn with invalid credentials
- [ ] Test signUp with valid data
- [ ] Test signUp with invalid data
- [ ] Test signUp with duplicate email
- [ ] Test getCurrentUser with stored session
- [ ] Test getCurrentUser without session
- [ ] Test signOut clears session
- [ ] Test resetPassword flow

#### Model Tests (user_test.dart)
- [ ] Test User model creation
- [ ] Test toJson serialization
- [ ] Test fromJson deserialization
- [ ] Test copyWith method
- [ ] Test field validation

### 3.6 Code Quality Criteria

#### Code Standards
- [ ] Code follows Flutter best practices
- [ ] Code style is consistent with existing app
- [ ] Private methods use underscore prefix
- [ ] Methods have clear, descriptive names
- [ ] Complex logic has explanatory comments
- [ ] No unnecessary code duplication
- [ ] Proper error handling throughout

#### Documentation
- [ ] Public methods have documentation comments
- [ ] Complex logic is explained with inline comments
- [ ] README or documentation includes authentication setup notes
- [ ] Any third-party packages are documented

#### Accessibility
- [ ] All input fields have proper labels
- [ ] Semantic labels are provided for screen readers
- [ ] Color is not the only indicator of state
- [ ] Touch targets are appropriately sized
- [ ] Focus order is logical

### 3.7 Performance Criteria

- [ ] Authentication operations complete within reasonable time
- [ ] No UI lag during validation
- [ ] Smooth animations and transitions
- [ ] Efficient use of setState()
- [ ] No memory leaks from improper disposal

---

## 4. Technical Implementation Requirements

### 4.1 Dependencies
- `shared_preferences` - For local session storage
- Standard Flutter packages (material, etc.)

### 4.2 File Structure


## Requirements

### 1. Create a Reusable Navigation Drawer Widget
- Create a new file: `lib/widgets/app_drawer.dart`
- Implement a custom Drawer widget that includes:
  - User profile header showing current user info (from AuthService)
  - Navigation items for:
    - Home/Order Screen (icon: Icons.home)
    - Cart (icon: Icons.shopping_cart) - should pass current cart instance
    - About (icon: Icons.info)
    - Sign Out (icon: Icons.logout) - with confirmation dialog
  - Highlight the currently active screen
  - Handle navigation properly (avoid duplicate screens in navigation stack)

### 2. Make Navigation Responsive
- **Mobile view (width < 600px)**: Show hamburger menu icon in AppBar, use Drawer
- **Tablet/Desktop view (width >= 600px)**: Show persistent NavigationRail or permanent drawer
- Use `LayoutBuilder` or `MediaQuery` to detect screen width
- Smooth transitions between layouts

### 3. Create a Base Scaffold Widget to Reduce Redundancy
- Create a new file: `lib/widgets/base_scaffold.dart`
- Implement a reusable scaffold that:
  - Includes the AppBar with hamburger menu (on mobile)
  - Includes the drawer/navigation rail based on screen size
  - Takes the body content as a parameter
  - Takes the page title as a parameter
  - Optionally takes AppBar actions
  - Manages the drawer/rail state internally

### 4. Integration Guidelines
- Update OrderScreen, CartScreen, and AboutScreen to use the BaseScaffold
- Ensure Cart instance is properly passed between screens
- Maintain existing functionality (logout, navigation, etc.)
- Keep AuthScreen separate (no drawer needed on login screen)
- CheckoutScreen can optionally exclude the drawer (it's a modal flow)

### 5. Drawer Widget Explanation
Include code comments explaining:
- How Drawer integrates with Scaffold (drawer property)
- How the hamburger icon appears automatically (via Scaffold.drawer)
- How to manually open drawer: `Scaffold.of(context).openDrawer()`
- How to close drawer after navigation: `Navigator.pop(context)`
- How to prevent multiple instances when navigating to current screen

### 6. Technical Requirements
- Use proper state management (setState where needed)
- Handle navigation edge cases (don't push if already on that screen)
- Use named routes if it simplifies the code
- Make drawer items visually appealing with proper spacing and colors
- Add dividers between logical sections
- Support both light theme (current app uses Colors.orange primary)

## Expected Deliverables

### 1. `lib/widgets/app_drawer.dart`
```dart
// Implement custom drawer with:
// - DrawerHeader with user info
// - ListTile items for each screen
// - Active page highlighting
// - Navigation logic
// - Logout confirmation