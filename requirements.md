# Requirements Document: Refactor Duplicated Widgets into Common Components

## 1. Overview

### 1.1 Project Name
Sandwich Shop App - Widget Refactoring Initiative

### 1.2 Document Version
Version 1.0 - December 12, 2025

### 1.3 Purpose
This document outlines the requirements for refactoring duplicated UI components across the Sandwich Shop Flutter application to improve code maintainability, consistency, and reduce technical debt.

### 1.4 Scope
This refactoring effort focuses on extracting duplicated widgets (specifically app bars and cart indicators) from individual screens into a centralized common widgets file.

---

## 2. Background and Problem Statement

### 2.1 Current State
The application currently has the following screens:
- OrderScreen
- CartScreen
- CheckoutScreen
- ProfileScreen
- SettingsScreen

Each screen independently implements:
- An app bar with logo
- Cart indicator badge
- Similar styling and layout patterns

### 2.2 Identified Problems
1. **Code Duplication**: App bar code is repeated across 5+ screens
2. **Inconsistency Risk**: Changes must be made in multiple locations
3. **Maintenance Burden**: Bug fixes require updates in multiple files
4. **Testing Overhead**: Each implementation requires separate test coverage
5. **Scalability Issues**: Adding new screens perpetuates the duplication

### 2.3 Impact
- Increased development time for new features
- Higher risk of UI inconsistencies
- Difficult to maintain brand consistency
- Larger codebase with redundant code

---

## 3. Goals and Objectives

### 3.1 Primary Goals
1. Eliminate code duplication across all screens
2. Create reusable, maintainable widget components
3. Establish a pattern for future common components
4. Improve overall code quality and maintainability

### 3.2 Secondary Goals
1. Reduce test file complexity
2. Simplify onboarding for new developers
3. Improve build times by reducing redundant code
4. Establish coding standards for widget reusability

### 3.3 Success Metrics
- [ ] Zero duplicate app bar implementations
- [ ] All 5 screens use common widgets
- [ ] All existing tests pass
- [ ] Code coverage maintained or improved
- [ ] No breaking changes to user functionality

---

## 4. Detailed Requirements

### 4.1 Functional Requirements

#### FR-1: Common Widgets File
**Priority**: High  
**Description**: Create a new file `lib/views/common_widgets.dart` to house all reusable widgets.

**Acceptance Criteria**:
- File created at correct location
- Proper imports for Material, Provider, Cart model
- Follows Flutter best practices
- Includes proper documentation

#### FR-2: CommonAppBar Widget
**Priority**: High  
**Description**: Implement a reusable app bar component.

**Specifications**:
```dart
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onCartTap;
  final bool showCartIndicator;
  
  const CommonAppBar({
    Key? key,
    required this.title,
    this.onCartTap,
    this.showCartIndicator = true,
  }) : super(key: key);
}
```

**Features**:
- Display logo on the left side
- Show customizable title text in center
- Display cart indicator on right (optional)
- Use heading1 style from app_styles.dart
- Support custom cart tap callback
- Implement PreferredSizeWidget for AppBar compatibility

**Acceptance Criteria**:
- Logo displays correctly from `assets/images/logo.png`
- Title uses heading1 style
- Cart indicator updates in real-time
- Widget is stateless and performant
- Supports all existing screen requirements

#### FR-3: CartIndicator Widget
**Priority**: High  
**Description**: Implement a standalone cart badge component.

**Specifications**:
```dart
class CartIndicator extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? badgeColor;
  
  const CartIndicator({
    Key? key,
    this.onTap,
    this.iconColor,
    this.badgeColor,
  }) : super(key: key);
}
```

**Features**:
- Show shopping cart icon
- Display badge with item count
- Use Consumer<Cart> for reactive updates
- Support custom colors
- Support tap callback
- Hide badge when cart is empty (count = 0)

**Acceptance Criteria**:
- Badge shows correct count at all times
- Updates automatically when cart changes
- Icon is clearly visible
- Badge positioned correctly over icon
- Supports customization options

#### FR-4: Screen Refactoring
**Priority**: High  
**Description**: Update all screens to use common widgets.

**Screens to Update**:
1. lib/views/order_screen.dart
2. lib/views/cart_screen.dart
3. lib/views/checkout_screen.dart
4. lib/views/profile_screen.dart
5. lib/views/settings_screen.dart

**Acceptance Criteria**:
- Remove duplicate app bar code from each screen
- Replace with CommonAppBar widget
- Maintain all existing functionality
- Preserve navigation behavior
- Keep all existing callbacks and interactions
- Update imports correctly

### 4.2 Non-Functional Requirements

#### NFR-1: Performance
- No performance degradation from refactoring
- Widget rebuilds only when necessary
- Efficient use of Consumer widgets
- Maintain 60fps UI performance

#### NFR-2: Maintainability
- Clear documentation for all public APIs
- Consistent naming conventions
- Proper code organization
- Follow Flutter style guide

#### NFR-3: Compatibility
- No breaking changes to existing functionality
- Backward compatible with current cart implementation
- Works with existing Provider setup
- Compatible with all supported Flutter versions

#### NFR-4: Testability
- All widgets must be testable
- Maintain or improve test coverage
- Update test files as needed
- Mock-friendly implementation

---

## 5. Technical Specifications

### 5.1 File Structure
```
lib/
├── views/
│   ├── common_widgets.dart          [NEW]
│   ├── order_screen.dart            [MODIFIED]
│   ├── cart_screen.dart             [MODIFIED]
│   ├── checkout_screen.dart         [MODIFIED]
│   ├── profile_screen.dart          [MODIFIED]
│   ├── settings_screen.dart         [MODIFIED]
│   └── app_styles.dart              [NO CHANGE]
└── models/
    └── cart.dart                     [NO CHANGE]

test/
└── views/
    ├── common_widgets_test.dart     [NEW]
    ├── order_screen_test.dart       [MODIFIED]
    ├── cart_screen_test.dart        [MODIFIED]
    ├── checkout_screen_test.dart    [MODIFIED]
    ├── profile_screen_test.dart     [MODIFIED]
    └── settings_screen_test.dart    [MODIFIED]
```

### 5.2 Dependencies
**Required**:
- flutter/material.dart
- provider (existing)
- sandwich_shop/models/cart.dart
- sandwich_shop/views/app_styles.dart

**No New Dependencies Required**

### 5.3 Implementation Details

#### CommonAppBar Implementation
```dart
@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);

@override
Widget build(BuildContext context) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    ),
    title: Text(
      title,
      style: AppStyles.heading1,
    ),
    actions: showCartIndicator
        ? [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CartIndicator(onTap: onCartTap),
            ),
          ]
        : null,
  );
}
```

#### CartIndicator Implementation
```dart
@override
Widget build(BuildContext context) {
  return Consumer<Cart>(
    builder: (context, cart, child) {
      final int itemCount = cart.totalQuantity;
      
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Icon(
              Icons.shopping_cart,
              color: iconColor ?? Colors.white,
              size: 28,
            ),
            if (itemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
```

### 5.4 Migration Strategy

#### Phase 1: Create Common Widgets
1. Create common_widgets.dart file
2. Implement CommonAppBar widget
3. Implement CartIndicator widget
4. Create unit tests for common widgets

#### Phase 2: Update Screens (One at a time)
1. Update SettingsScreen (least complex)
2. Update ProfileScreen
3. Update CheckoutScreen
4. Update CartScreen
5. Update OrderScreen (most complex)

#### Phase 3: Update Tests
1. Update test files for each screen
2. Ensure all tests pass
3. Add integration tests if needed

#### Phase 4: Cleanup
1. Remove unused code
2. Update documentation
3. Final testing and validation

---

## 6. Testing Requirements

### 6.1 Unit Tests

#### Common Widgets Tests
**File**: `test/views/common_widgets_test.dart`

Required Tests:
- [ ] CommonAppBar displays title correctly
- [ ] CommonAppBar shows logo
- [ ] CommonAppBar shows/hides cart indicator based on parameter
- [ ] CommonAppBar calls onCartTap when cart is tapped
- [ ] CommonAppBar has correct preferredSize
- [ ] CartIndicator displays correct count
- [ ] CartIndicator updates when cart changes
- [ ] CartIndicator hides badge when count is 0
- [ ] CartIndicator calls onTap callback
- [ ] CartIndicator supports custom colors

#### Screen Tests
Each screen test file must verify:
- [ ] CommonAppBar is used instead of custom AppBar
- [ ] All existing functionality preserved
- [ ] Navigation works correctly
- [ ] Cart interactions work properly
- [ ] Visual regression tests pass

### 6.2 Integration Tests
- [ ] Cart count updates across all screens
- [ ] Navigation between screens works
- [ ] Cart additions/removals reflect everywhere
- [ ] No memory leaks from Provider

### 6.3 Manual Testing Checklist
- [ ] Visual inspection of all screens
- [ ] Cart badge updates in real-time
- [ ] Logo displays correctly on all screens
- [ ] Tap interactions work as expected
- [ ] No UI glitches or flickering
- [ ] Consistent appearance across screens

---

## 7. Documentation Requirements

### 7.1 Code Documentation
- [ ] Dartdoc comments for all public classes
- [ ] Parameter documentation
- [ ] Usage examples in comments
- [ ] Edge case documentation

### 7.2 README Updates
- [ ] Document common widgets usage
- [ ] Add migration guide
- [ ] Update architecture documentation
- [ ] Add examples of common widget usage

### 7.3 Developer Guidelines
- [ ] When to use CommonAppBar
- [ ] How to customize common widgets
- [ ] Best practices for reusable widgets
- [ ] Testing guidelines

---

## 8. Success Criteria

### 8.1 Code Quality Metrics
- [ ] Zero code duplication for app bar
- [ ] Test coverage ≥ 90% for common widgets
- [ ] All existing tests passing
- [ ] No new linter warnings
- [ ] Code complexity reduced

### 8.2 Functional Criteria
- [ ] All screens use CommonAppBar
- [ ] Cart indicator works on all screens
- [ ] No regression in existing features
- [ ] Navigation unchanged
- [ ] Performance maintained

### 8.3 User Experience Criteria
- [ ] Consistent UI across all screens
- [ ] No visual changes from user perspective
- [ ] All interactions work as before
- [ ] No new bugs introduced

---

## 9. Risks and Mitigation

### 9.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing functionality | Medium | High | Comprehensive testing, phased rollout |
| Provider issues | Low | Medium | Review Provider usage, add tests |
| Performance degradation | Low | Medium | Performance profiling before/after |
| Test failures | Medium | Medium | Update tests incrementally |
| Merge conflicts | Medium | Low | Frequent commits, clear communication |

### 9.2 Project Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Scope creep | Medium | Medium | Strict adherence to requirements |
| Timeline delays | Low | Low | Buffer time in schedule |
| Unclear requirements | Low | High | This requirements document |
| Inadequate testing | Medium | High | Comprehensive test plan |

---

## 10. Timeline and Milestones

### 10.1 Estimated Timeline
**Total Duration**: 2-3 days

### 10.2 Milestones

#### Milestone 1: Common Widgets Creation (Day 1)
- [ ] Create common_widgets.dart
- [ ] Implement CommonAppBar
- [ ] Implement CartIndicator
- [ ] Write unit tests
- [ ] Code review

#### Milestone 2: Screen Migration (Day 2)
- [ ] Update SettingsScreen
- [ ] Update ProfileScreen
- [ ] Update CheckoutScreen
- [ ] Update CartScreen
- [ ] Update OrderScreen
- [ ] Update all test files

#### Milestone 3: Testing and Validation (Day 3)
- [ ] Run all unit tests
- [ ] Perform integration testing
- [ ] Manual testing
- [ ] Fix any issues
- [ ] Documentation updates
- [ ] Final code review

---

## 11. Acceptance Criteria

### 11.1 Definition of Done
This refactoring is considered complete when:

1. **Code Changes**
   - [ ] common_widgets.dart file created with all required widgets
   - [ ] All 5 screens refactored to use common widgets
   - [ ] No duplicate app bar code remains
   - [ ] All imports correct and optimized

2. **Testing**
   - [ ] All existing tests pass
   - [ ] New tests added for common widgets
   - [ ] Test coverage maintained or improved
   - [ ] No test failures in CI/CD pipeline

3. **Documentation**
   - [ ] Code properly documented
   - [ ] README updated
   - [ ] Developer guidelines created
   - [ ] Migration notes documented

4. **Quality Assurance**
   - [ ] Code review completed and approved
   - [ ] No linter warnings
   - [ ] Performance benchmarks met
   - [ ] Manual testing completed

5. **Deployment**
   - [ ] Changes merged to main branch
   - [ ] Build successful
   - [ ] App runs without errors
   - [ ] No user-facing changes

---

## 12. Deliverables

### 12.1 Primary Deliverables
1. `lib/views/common_widgets.dart` - New file with reusable widgets
2. Updated screen files (5 files)
3. `test/views/common_widgets_test.dart` - New test file
4. Updated test files (5 files)

### 12.2 Documentation Deliverables
1. Updated README.md
2. Code documentation (Dartdoc)
3. Migration guide
4. This requirements document

### 12.3 Validation Deliverables
1. Test report showing all tests passing
2. Code review approval
3. Performance comparison report
4. List of modified files

---

## 13. Approval and Sign-off

### 13.1 Stakeholders
- **Developer**: Implementation and testing
- **Code Reviewer**: Quality assurance
- **Project Lead**: Final approval

### 13.2 Review Process
1. Developer completes implementation
2. Self-review and testing
3. Submit for code review
4. Address review comments
5. Final approval and merge

---

## 14. Appendix

### 14.1 Related Documents
- Original prompt.md
- Flutter Style Guide
- Project Architecture Documentation

### 14.2 References
- Flutter Widget Best Practices
- Provider Package Documentation
- Dart Style Guide

### 14.3 Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-12 | GitHub Copilot | Initial requirements document |

---

**Document Status**: Draft  
**Last Updated**: December 12, 2025  
**Next Review Date**: Upon completion of implementation