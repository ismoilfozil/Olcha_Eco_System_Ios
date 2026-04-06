# Barcode API Integration

This document describes the API integration for the barcode generation feature.

## API Endpoint

```
POST https://merchant.olchanasiya.uz/api/barcode/generate
```

### Request

**Method:** `POST`

**Query Parameters:**
- `user_id` (required) - The user ID for whom to generate the barcode

**Headers:**
```
Authorization: Basic YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw=
Accept-Language: {current_app_language}
```

### Response

**Success Response (200 OK):**
```json
{
  "code": "123456789012",
  "message": "Success"
}
```

**Error Response:**
```json
{
  "code": null,
  "message": "Error message"
}
```

## File Structure

```
Domain/
├── Entities/
│   └── Barcode/
│       └── BarcodeResponse.swift          # Response model
├── UseCases/
│   └── Barcode/
│       ├── BarcodeAPI.swift               # API endpoint definition
│       └── BarcodeUseCase.swift           # Business logic
└── Repositories/
    └── Barcode/
        └── BarcodeRepository.swift        # Data layer

Presentations/
└── Tabs/
    └── Payment/
        └── Confirmation/
            ├── view/
            │   ├── ConfirmationViewController.swift
            │   └── FullscreenBarcodeViewController.swift
            └── viewModel/
                └── ConfirmationViewModel.swift
```

## Implementation Details

### 1. BarcodeResponse (Domain/Entities/Barcode/BarcodeResponse.swift)

```swift
public struct BarcodeResponse: Codable {
    public let code: String?
    public let message: String?
}
```

### 2. BarcodeAPI (Domain/UseCases/Barcode/BarcodeAPI.swift)

Defines the API endpoint with custom base URL and Basic authentication:

```swift
public enum BarcodeAPI {
    case generate(userId: Int)
}

extension BarcodeAPI: BaseAPI {
    public var baseURL: String {
        return "https://merchant.olchanasiya.uz"
    }

    public var headers: ApiHeader {
        return BarcodeAPIHeader.shared
    }

    // ... other API configurations
}
```

### 3. BarcodeRepository (Domain/Repositories/Barcode/BarcodeRepository.swift)

Handles data fetching:

```swift
public protocol BarcodeRepositoryProtocol {
    func generateBarcode(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never>
}

public class BarcodeRepository: BaseRepository, BarcodeRepositoryProtocol {
    public func generateBarcode(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never> {
        let api: BarcodeAPI = .generate(userId: userId)
        return manager.request(api: api, isSingleRequest: false, isCancellable: false)
    }
}
```

### 4. BarcodeUseCase (Domain/UseCases/Barcode/BarcodeUseCase.swift)

Encapsulates business logic:

```swift
public protocol GenerateBarcodeProtocol {
    func execute(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never>
}

public enum BarcodeUseCase {
    public class GenerateBarcode: GenerateBarcodeProtocol {
        private let repository: BarcodeRepositoryProtocol

        public func execute(userId: Int) -> AnyPublisher<BaseResponse<BarcodeResponse, EmptyData>, Never> {
            return repository.generateBarcode(userId: userId)
        }
    }
}
```

### 5. ConfirmationViewModel (Presentations/.../viewModel/ConfirmationViewModel.swift)

Manages state and coordinates between view and use case:

```swift
public class ConfirmationViewModel: BaseViewModel {
    @Published var barcodeData: LoadingState<BarcodeResponse, BaseErrorType> = .standart

    private let generateBarcodeUseCase: GenerateBarcodeProtocol

    public func generateBarcode(userId: Int) {
        barcodeData = .loading
        generateBarcodeUseCase.execute(userId: userId)
            .sink { [weak self] baseResponse in
                // Handle response
            }.store(in: &bag)
    }
}
```

### 6. ConfirmationViewController (Presentations/.../view/ConfirmationViewController.swift)

Displays the UI and binds to ViewModel:

```swift
public class ConfirmationViewController: BaseViewController {
    var viewModel: ConfirmationViewModel!

    private func bindViewModel() {
        viewModel.$barcodeData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.showLoader()
                case .success(let response):
                    self?.setCode(response.code ?? "")
                case .failure(let error):
                    self?.showToast(message: error.message, type: .error)
                }
            }
            .store(in: &cancellables)
    }
}
```

## Data Flow

```
User Action (Open Screen / Tap Refresh)
    ↓
ViewController.configure(userId:)
    ↓
ViewModel.generateBarcode(userId:)
    ↓
UseCase.execute(userId:)
    ↓
Repository.generateBarcode(userId:)
    ↓
API Request (BarcodeAPI)
    ↓
Response (BarcodeResponse)
    ↓
ViewModel updates @Published barcodeData
    ↓
ViewController receives update via Combine
    ↓
UI Updates (Display QR Code, Start Timer)
```

## Usage in Coordinator

```swift
// In your coordinator or DI setup
func showConfirmationScreen(userId: Int) {
    // 1. Setup dependencies
    let repository = BarcodeRepository()
    let useCase = BarcodeUseCase.GenerateBarcode(repository: repository)
    let viewModel = ConfirmationViewModel(generateBarcodeUseCase: useCase)

    // 2. Create view controller
    let viewController = ConfirmationViewController()
    viewController.viewModel = viewModel

    // 3. Configure with user ID
    viewController.configure(userId: userId)

    // 4. Push to navigation
    navigationController.pushViewController(viewController, animated: true)
}
```

## Error Handling

The implementation handles the following scenarios:

1. **Network Error**: Shows error toast with message
2. **Empty Code**: Shows warning toast if code is nil but message exists
3. **Loading State**: Shows loader while fetching
4. **Success**: Generates QR code and starts 45-second timer

## Testing

To test the API integration:

1. Use a valid user ID
2. Verify the Basic auth token is correct
3. Check network logs for request/response
4. Test error scenarios (invalid userId, network timeout)
5. Test refresh functionality

## Security Notes

- The Basic authentication token is hardcoded as per Android implementation
- Token: `YXBpX21lcmNoYW50Ono6UzXCo0t1Q2w3XXo8N0IxaTZLeUI4cWt2SGw=`
- Consider moving to a more secure authentication method in production
- Ensure HTTPS is always used for API calls
