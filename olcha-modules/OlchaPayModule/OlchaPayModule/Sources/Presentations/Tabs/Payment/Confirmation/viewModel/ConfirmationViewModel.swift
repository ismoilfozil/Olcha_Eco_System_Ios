//
//  ConfirmationViewModel.swift
//  OlchaPayModule
//
//  Created by Claude Code
//

import Foundation
import OlchaUI
import OlchaCore
import Combine

public class ConfirmationViewModel: BaseViewModel {

    @Published var barcodeData: LoadingState<BarcodeResponse, BaseErrorType> = .standart

    private let generateBarcodeUseCase: GenerateBarcodeProtocol

    public init(generateBarcodeUseCase: GenerateBarcodeProtocol) {
        self.generateBarcodeUseCase = generateBarcodeUseCase
    }

    /// Generate a new barcode for the given user ID
    public func generateBarcode(userId: Int) {
        barcodeData = .loading

        generateBarcodeUseCase.execute(userId: userId)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    if let response = baseResponse.response {
                        self.barcodeData = .success(response)
                    } else {
                        self.barcodeData = .failure(.init(message: baseResponse.error))
                    }
                case .fail, .canceled:
                    self.barcodeData = .failure(.init(message: baseResponse.error))
                }
            }.store(in: &bag)
    }

    /// Refresh the barcode (generate a new one)
    public func refreshBarcode(userId: Int) {
        generateBarcode(userId: userId)
    }
}
