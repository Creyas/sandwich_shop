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