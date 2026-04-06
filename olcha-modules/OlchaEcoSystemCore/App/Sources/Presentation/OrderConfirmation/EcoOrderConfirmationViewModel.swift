import Foundation
import Combine

public class EcoOrderConfirmationViewModel {


    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var confirmationResult: OrderConfirmationResult?
    @Published public var orderConfirmationCode: String?

    private var cancellables = Set<AnyCancellable>()
    private let barcodeRepository: BarcodeRepositoryProtocol
    private let userId: Int


    public init(barcodeRepository: BarcodeRepositoryProtocol, userId: Int) {
        self.barcodeRepository = barcodeRepository
        self.userId = userId
    }


    public func fetchBarcode(completion: @escaping (Bool, String?) -> Void) {
        isLoading = true

        barcodeRepository.generateBarcode(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] barcodeResponse in
                guard let self = self else { return }

                self.isLoading = false

                if let response = barcodeResponse, response.success {
                    self.orderConfirmationCode = response.code
                    completion(true, response.code)
                } else {
                    self.errorMessage = "Failed to generate barcode"
                    completion(false, nil)
                }
            }
            .store(in: &cancellables)
    }


    public func confirmOrder(code: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true


        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }

            self.isLoading = false


            if code.isEmpty {
                self.errorMessage = "Invalid code"
                completion(false, "Invalid code")
                return
            }


            let result = OrderConfirmationResult(
                orderId: code,
                status: "confirmed",
                timestamp: Date()
            )

            self.confirmationResult = result
            completion(true, "Order \(code) confirmed successfully!")
        }
    }

    public func validateCode(_ code: String) -> Bool {
        return !code.isEmpty && code.count >= 3
    }
}


public struct OrderConfirmationResult {
    public let orderId: String
    public let status: String
    public let timestamp: Date

    public init(orderId: String, status: String, timestamp: Date) {
        self.orderId = orderId
        self.status = status
        self.timestamp = timestamp
    }
}
