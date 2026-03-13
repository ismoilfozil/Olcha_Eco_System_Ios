# EcoHome Screen Button Integration

This document describes the integration of the Barcode Confirmation button on the EcoHome screen.

## Overview

Added a new "Barcode" app icon to the EcoHome screen that opens the barcode confirmation screen when tapped. The button appears in the apps grid section along with other services like Market, Sayohat, Nasiya, Invest, and Pay.

## Changes Made

### 1. EcoAppService Enum Update

**File:** [EcoHomeViewController+Table.swift](olcha-modules/OlchaEcoSystemCore/App/Sources/Presentation/Home/Common/EcoHomeViewController/EcoHomeViewController+Table.swift)

Added new `.barcode` case to the enum:

```swift
public enum EcoAppService: Int, RowProtocol {
    case market
    case sayohat
    case nasiya
    case invest
    case pay
    case barcode  // NEW
    case cashback
    case tv
    case food
    case myId
    case bus
}
```

**Image Configuration:**
```swift
case .barcode: return UIImage(systemName: "barcode.viewfinder")
```
Uses SF Symbols icon for barcode.

**Title Configuration:**
```swift
case .barcode: return "home_module_barcode".localized(.olchaEcoSystemCore)
```

**Enabled State:**
```swift
case .market, .nasiya, .invest, .pay, .barcode:
    return true
```

### 2. Items Array Update

**File:** [EcoHomeAppTableCell+Collection.swift](olcha-modules/OlchaEcoSystemCore/App/Sources/Presentation/Home/AppTableCell/EcoHomeAppTableCell+Collection.swift)

Added `.barcode` to the items array:

```swift
public var items: [EcoHomeViewController.EcoAppService] {
    [.market, .sayohat, .nasiya, .invest, .pay, .barcode, .cashback, .tv, .food, .myId, .bus]
}
```

The barcode icon will appear in the 6th position in the grid.

### 3. Coordinator Protocol

**File:** [EcoHomeCoordinator.swift](olcha-modules/OlchaEcoSystemCore/App/Sources/Presentation/Home/Common/EcoHomeCoordinator.swift)

Added method to coordinator protocol:

```swift
func pushConfirmationScreen()
```

### 4. Coordinator Implementation

**File:** [EcoHomeCoordinator.swift](olcha-modules/OlchaEcoSystemCore/App/Sources/Presentation/Home/Common/EcoHomeCoordinator.swift)

Implemented the navigation method:

```swift
public func pushConfirmationScreen() {
    // Setup dependencies
    let repository = BarcodeRepository()
    let useCase = BarcodeUseCase.GenerateBarcode(repository: repository)
    let viewModel = ConfirmationViewModel(generateBarcodeUseCase: useCase)

    // Create view controller
    let vc = ConfirmationViewController()
    vc.viewModel = viewModel

    // Get user ID from AuthGlobalDefaults
    let userId = AuthGlobalDefaults.user.id ?? 0
    vc.configure(userId: userId)

    vc.onBack = { [weak self] in
        self?.navigationController.popViewController(animated: true)
    }

    navigationController.push(vc)
}
```

### 5. Action Handler in EcoHomeViewController

**File:** [EcoHomeViewController.swift](olcha-modules/OlchaEcoSystemCore/App/Sources/Presentation/Home/Common/EcoHomeViewController/EcoHomeViewController.swift)

Added action handler for barcode service:

```swift
output.observers.appServiceSubject.sink { [weak self] service in
    guard let self else { return }
    switch service {
    case .invest:
        ModuleGeneratorHelper.shared.generate(module: .invest, appStarted: nil)
    case .market:
        ModuleGeneratorHelper.shared.generate(module: .olcha, appStarted: nil)
    case .nasiya:
        ModuleGeneratorHelper.shared.generate(module: .nasiya, appStarted: nil)
    case .pay:
        ModuleGeneratorHelper.shared.generate(module: .pay, appStarted: nil)
    case .barcode:  // NEW
        coordinator?.pushConfirmationScreen()
    default:
        self.showInvalidSnackbar(container)
    }
}.store(in: &bag)
```

### 6. Localization Strings

**Files:**
- `OlchaEcoSystemCore/App/Resources/en.lproj/Localizable.strings`
- `OlchaEcoSystemCore/App/Resources/ru.lproj/Localizable.strings`

Added app icon label:

```swift
"home_module_barcode" = "Barcode"      // English
"home_module_barcode" = "Штрих-код"    // Russian
```

## User Flow

1. User opens the Olcha EcoSystem app
2. User sees the EcoHome screen with app icons grid
3. User scrolls to find the "Barcode" icon (appears after Pay icon)
4. User taps the "Barcode" icon
5. App fetches barcode from API using current user's ID
6. Confirmation screen opens showing:
   - QR code
   - Formatted numeric code
   - 45-second countdown timer
   - Progress bar
7. User can:
   - Tap QR code to view fullscreen barcode
   - Wait for code to expire and tap "Refresh Code"
   - Tap back button to return to EcoHome screen

## UI Layout

### EcoHome Apps Grid

The apps appear in a 5-column grid layout:

```
Row 1: [Market] [Sayohat] [Nasiya] [Invest] [Pay]
Row 2: [Barcode] [Cashback] [TV] [Food] [MyID]
Row 3: [Bus]
```

The Barcode icon:
- Uses SF Symbols `barcode.viewfinder` icon
- Displays label "Barcode" (or "Штрих-код" in Russian)
- Is enabled (can be tapped)
- Appears in color (not grayed out)

## Technical Details

### Dependencies Initialization

The confirmation screen dependencies are created inline in the coordinator:

- `BarcodeRepository` - Handles API calls to `https://merchant.olchanasiya.uz`
- `BarcodeUseCase.GenerateBarcode` - Business logic
- `ConfirmationViewModel` - State management
- `ConfirmationViewController` - UI presentation

### User ID Source

The user ID is retrieved from `AuthGlobalDefaults.user.id`:

```swift
let userId = AuthGlobalDefaults.user.id ?? 0
```

If the user ID is `nil`, it defaults to `0`.

### Navigation

The confirmation screen is pushed onto the navigation stack:

```swift
navigationController.push(vc)
```

Back navigation is handled via closure:

```swift
vc.onBack = { [weak self] in
    self?.navigationController.popViewController(animated: true)
}
```

### Icon

Uses SF Symbols for the icon:
- Symbol name: `barcode.viewfinder`
- System-provided, always available
- Scales automatically with text size
- Supports dark mode automatically

## Comparison with PayModule Integration

| Feature | PayModule | EcoSystemCore |
|---------|-----------|---------------|
| **Location** | Horizontal menu bar | Apps grid (5 columns) |
| **Icon** | Text button | SF Symbol icon |
| **Position** | After "QR Scan" | After "Pay" |
| **Layout** | ScrollView collection | Table cell collection |
| **Pattern** | Menu item | App service icon |

## Testing

To test the integration:

1. Run the Olcha EcoSystem app
2. Navigate to the home screen (default tab)
3. Scroll down to see the apps grid
4. Look for the barcode icon (row 2, position 1)
5. Tap the barcode icon
6. Verify the confirmation screen opens
7. Verify the API is called with the correct user ID
8. Verify the QR code and timer display correctly
9. Test the back button functionality
10. Test rotation and orientation changes

## Error Handling

Same as PayModule integration:
- Error toast shown on API failure
- User can tap "Refresh Code" to retry
- Loading indicator during API call
- User ID defaults to 0 if not available

## Future Enhancements

1. Add custom barcode icon instead of SF Symbol
2. Add badge/notification indicator for new codes
3. Add recently used codes list
4. Add quick access from notification
5. Add widget support
6. Add shortcut to barcode from lock screen
7. Consider moving to prominent position (row 1)

## Notes

- No DI container registration needed (dependencies created inline)
- Works with existing authentication system
- Follows existing coordinator pattern
- Uses SF Symbols for icon (always available)
- Supports both English and Russian languages
- Appears in enabled state (not grayed out)
- Position: Row 2, Column 1 in the apps grid

## Module Dependencies

The EcoHomeCoordinator now depends on:
- `OlchaPayModule` (already imported)
  - For `BarcodeRepository`
  - For `BarcodeUseCase`
  - For `ConfirmationViewModel`
  - For `ConfirmationViewController`

These types are all defined in OlchaPayModule, so no additional imports needed.
