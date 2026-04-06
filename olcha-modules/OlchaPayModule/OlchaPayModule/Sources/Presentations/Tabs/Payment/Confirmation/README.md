# Confirmation Screen

This module implements a one-time code confirmation screen for iOS, matching the Android implementation.

## Features

- **QR Code Display**: Shows a scannable QR code for quick payment processing
- **Numeric Code**: Displays a formatted numeric code that can be manually entered
- **Countdown Timer**: 45-second countdown with visual progress bar
- **Expired State**: Automatic transition to expired state when timer reaches zero
- **Barcode Fullscreen**: Tap QR code to view barcode in fullscreen mode
- **Refresh Functionality**: Ability to refresh expired codes

## Files

### ConfirmationViewController.swift
Main view controller displaying the confirmation screen with two states:
- **Active State**: Shows QR code, numeric code, timer, and progress bar
- **Expired State**: Shows expired message with refresh button

### FullscreenBarcodeViewController.swift
Modal view controller for displaying barcode in fullscreen.

## Usage Example

```swift
// Initialize the dependencies
let repository = BarcodeRepository()
let useCase = BarcodeUseCase.GenerateBarcode(repository: repository)
let viewModel = ConfirmationViewModel(generateBarcodeUseCase: useCase)

// Create and configure the confirmation view controller
let confirmationVC = ConfirmationViewController()
confirmationVC.viewModel = viewModel

// Configure with user ID to generate barcode
let userId = 12345
confirmationVC.configure(userId: userId)

// Handle back action (optional)
confirmationVC.onBack = { [weak self] in
    // Handle navigation back
    self?.dismiss(animated: true)
}

// Present or push the view controller
navigationController?.pushViewController(confirmationVC, animated: true)
```

### Manual Code Setting (without API)

If you want to set a code manually without API:

```swift
let confirmationVC = ConfirmationViewController()
confirmationVC.setCode("123456789012")
navigationController?.pushViewController(confirmationVC, animated: true)
```

## Localization

All strings are localized in `OlchaResources/Resources/Strings/[locale].lproj/Localizable.strings`:

- `your_one_time_code` - Toolbar title
- `scan_the_code_below` - Instruction text
- `code_placeholder` - Placeholder for numeric code
- `expires_in_45s` - Initial timer text
- `expires_in_%ds` - Timer text format (with seconds)
- `qr_code` - QR code accessibility label
- `code_expired` - Expired state title
- `please_request_new_code` - Expired state message
- `refresh_code` - Refresh button text
- `close` - Close button text

## Implementation Details

### QR Code Generation
Uses `CIQRCodeGenerator` Core Image filter to generate QR codes from string data.

### Barcode Generation
Uses `CICode128BarcodeGenerator` Core Image filter to generate barcodes for fullscreen display.

### Timer Implementation
- Uses `Timer.scheduledTimer` for countdown
- Updates every second
- Automatically animates progress bar
- Triggers expired state at 0 seconds

### State Management
- `activeStateContainer` - Contains QR code and timer
- `expiredStateContainer` - Contains expired message and refresh button
- Smooth animated transitions between states

## API Integration

### Backend API

The barcode is fetched from:
```
POST https://merchant.olchanasiya.uz/api/barcode/generate?user_id={userId}
Authorization: Basic YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw=
```

**Response:**
```json
{
  "code": "123456789012",
  "message": "Success"
}
```

### Architecture

The implementation follows Clean Architecture:

1. **Domain Layer**:
   - `BarcodeResponse` - Response model
   - `BarcodeAPI` - API endpoint definition
   - `BarcodeRepository` - Repository protocol and implementation
   - `BarcodeUseCase` - Use case for generating barcode

2. **Presentation Layer**:
   - `ConfirmationViewModel` - Handles business logic and state
   - `ConfirmationViewController` - UI controller
   - `FullscreenBarcodeViewController` - Fullscreen barcode modal

## Coordinator Integration

To integrate with your coordinator:

```swift
extension PaymentsCoordinator {
    func pushConfirmationScreen(userId: Int) {
        // Setup dependencies
        let repository = BarcodeRepository()
        let useCase = BarcodeUseCase.GenerateBarcode(repository: repository)
        let viewModel = ConfirmationViewModel(generateBarcodeUseCase: useCase)

        // Create view controller
        let vc = ConfirmationViewController()
        vc.viewModel = viewModel
        vc.configure(userId: userId)

        vc.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        navigationController.push(vc)
    }
}
```

## Design Specifications

### Active State
- QR Code: 120x120 points, centered with 32pt margins
- Numeric Code: 28sp, semibold, black
- Timer: 14sp, regular, black
- Progress Bar: 4pt height, main color tint

### Expired State
- Icon Container: 200x200 points, circular, light gray background
- Icon: 80x80 points, centered
- Title: 22sp, semibold, black
- Message: 14sp, regular, gray
- Refresh Button: 40pt height, main color background, white text

### Fullscreen Barcode
- Barcode: 150pt height, centered
- Numeric Code: 36sp, bold, above barcode
- Close Button: 48x48 points, top-left corner

## Dependencies

- `UIKit` - Core UI framework
- `OlchaUI` - Custom UI components and styles
- `SnapKit` - Auto layout constraints
- `CoreImage` - QR code and barcode generation
