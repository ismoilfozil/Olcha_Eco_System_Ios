# Home Screen Button Integration

This document describes the integration of the Barcode Confirmation button on the home screen.

## Changes Made

### 1. HomeMenuView Section Addition

**File:** [HomeMenuView+Collection.swift](olcha-modules/OlchaPayModule/OlchaPayModule/Sources/Presentations/Tabs/Main/HomePage/view/Rooms/HomeMenu/HomeMenuView+Collection.swift)

Added new `confirmation` section to the menu enum:

```swift
enum Section {
    case my_cards
    case qr
    case confirmation  // NEW
    case dots
}
```

Added cell configuration for confirmation button:

```swift
case .confirmation:
    let cell = collectionView.dequeue(HomeMenuItem.self, for: indexPath)
    cell.setup(with: "barcode_confirmation".localized())
    cell.button.clicked { [weak self] in
        guard let self = self else { return }
        buttonClickObserver?(.confirmation)
    }
    return cell
```

### 2. HomeMenuView Sections Array

**File:** [HomeMenuView.swift](olcha-modules/OlchaPayModule/OlchaPayModule/Sources/Presentations/Tabs/Main/HomePage/view/Rooms/HomeMenu/HomeMenuView.swift)

Added `.confirmation` to the sections array:

```swift
let sections: [Section] = [
    .my_cards,
    .qr,
    .confirmation,  // NEW
//  .dots
]
```

### 3. Coordinator Protocol

**File:** [PayHomeCoordinator.swift](olcha-modules/OlchaPayModule/OlchaPayModule/Sources/Presentations/Tabs/Main/Coordinator/PayHomeCoordinator.swift)

Added method to coordinator protocol:

```swift
func pushConfirmationScreen()
```

### 4. Coordinator Implementation

**File:** [PayHomeCoordinator.swift](olcha-modules/OlchaPayModule/OlchaPayModule/Sources/Presentations/Tabs/Main/Coordinator/PayHomeCoordinator.swift)

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

### 5. HomeViewController Action Handler

**File:** [HomeViewController.swift](olcha-modules/OlchaPayModule/OlchaPayModule/Sources/Presentations/Tabs/Main/HomePage/view/HomeViewController.swift)

Added action handler for confirmation button:

```swift
homeMenuView.clickedObserver { [weak self] section in
    guard let self = self else { return }
    switch section {
    case .qr:
        self.coordinator?.pushQR()
        break
    case .my_cards:
        Funcs.changeTab(PayTab.cards)
        break
    case .confirmation:  // NEW
        self.coordinator?.pushConfirmationScreen()
        break
    default:
        break
    }
}
```

### 6. Localization Strings

**Files:**
- `OlchaResources/Resources/Strings/en.lproj/Localizable.strings`
- `OlchaResources/Resources/Strings/ru.lproj/Localizable.strings`

Added button label:

```swift
"barcode_confirmation" = "Barcode"       // English
"barcode_confirmation" = "Штрих-код"     // Russian
```

## User Flow

1. User opens the app and sees the home screen
2. User scrolls horizontally in the menu bar to see options: "My Cards", "QR Scan", "Barcode"
3. User taps the "Barcode" button
4. App fetches barcode from API using current user's ID
5. Confirmation screen opens showing:
   - QR code
   - Formatted numeric code
   - 45-second countdown timer
   - Progress bar
6. User can:
   - Tap QR code to view fullscreen barcode
   - Wait for code to expire and tap "Refresh Code"
   - Tap back button to return to home screen

## Technical Details

### Dependencies Initialization

The confirmation screen dependencies are created inline in the coordinator:

- `BarcodeRepository` - Handles API calls
- `BarcodeUseCase.GenerateBarcode` - Business logic
- `ConfirmationViewModel` - State management
- `ConfirmationViewController` - UI presentation

### User ID Source

The user ID is retrieved from `AuthGlobalDefaults.user.id`:

```swift
let userId = AuthGlobalDefaults.user.id ?? 0
```

If the user ID is `nil`, it defaults to `0`. You may want to handle this case differently in production (e.g., show login screen).

### Navigation

The confirmation screen is pushed onto the navigation stack using:

```swift
navigationController.push(vc)
```

The back button is handled via closure:

```swift
vc.onBack = { [weak self] in
    self?.navigationController.popViewController(animated: true)
}
```

## UI Preview

### Home Screen Menu Bar

```
┌─────────────────────────────────────────────┐
│  [My Cards]  [QR Scan]  [Barcode]           │
└─────────────────────────────────────────────┘
```

The menu bar is horizontally scrollable, so all three buttons are visible.

## Testing

To test the integration:

1. Run the app
2. Navigate to the home screen (should be the default tab)
3. Look for the menu bar with buttons below the balance section
4. Tap the "Barcode" button
5. Verify the confirmation screen opens
6. Verify the API is called with the correct user ID
7. Verify the QR code and timer display correctly
8. Test the back button functionality

## Error Handling

If the API fails:
- Error toast is shown with message
- User can tap "Refresh Code" to retry
- Loading indicator shows during API call

If user ID is missing:
- Currently defaults to `0`
- Consider adding validation or redirecting to login

## Future Enhancements

1. Add user ID validation before navigating
2. Cache the last generated code
3. Add analytics tracking for button taps
4. Add haptic feedback on button tap
5. Consider adding the button to other screens
6. Add permission checks if needed

## Notes

- No DI container registration needed (dependencies created inline)
- Works with existing authentication system
- Follows existing coordinator pattern
- Uses existing UI components (HomeMenuItem)
- Supports both English and Russian languages
