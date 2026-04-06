//
//  MakeTransactionViewModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/01/24.
//

import Foundation
import Combine
import OlchaUI
import OlchaUtils
import OlchaCore

public class MakeTransactionViewModel: BaseViewModel {
    
    @Published var makeTransaction: LoadingState<TransactionOtpData, BaseErrorType> = .standart
    @Published var retryTransaction: LoadingState<TransactionOtpData, BaseErrorType> = .standart
    @Published var transactionVerifyOtp: LoadingState<TransactionData, BaseErrorType> = .standart
    
    private let makeTransactionGetOtpUseCase: MakeTransactionGetOtpProtocol
    private let makeTransactionVerifyOtpUseCase: MakeTransactionVerifyOtpProtocol
    
    public init(makeTransactionGetOtpUseCase: MakeTransactionGetOtpProtocol,
                makeTransactionVerifyOtpUseCase: MakeTransactionVerifyOtpProtocol
    ) {
        self.makeTransactionGetOtpUseCase = makeTransactionGetOtpUseCase
        self.makeTransactionVerifyOtpUseCase = makeTransactionVerifyOtpUseCase
    }
    
    func makeTransaction(helper: MakePaymentHelper) {
        
        guard let cardID = helper.selectedCard?.id else {
            makeTransaction = .failure(.init(message: "card_not_selected".localized()))
            makeTransaction = .standart
            return
        }
        
        guard let serviceID = helper.service?.id else {
            makeTransaction = .failure(.init(message: "service_not_exist".localized()))
            makeTransaction = .standart
            return
        }
        
        guard let providerID = helper.provider?.id else {
            makeTransaction = .failure(.init(message: "service_not_exist".localized()))
            makeTransaction = .standart
            return
        }
        makeTransaction = .loading
        makeTransactionGetOtpUseCase.execute(
            request: .init(service_id: serviceID,
                           card_id: cardID,
                           provider_id: providerID,
                           fields: helper.fields)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                print("calc data", baseResponse.response)
                self.makeTransaction = .success(baseResponse.response)
                break
            default:
                self.makeTransaction = .failure(.init(message: baseResponse.error))
                break
            }
            makeTransaction = .standart
        }.store(in: &bag)
    }
    
    public func retryTransaction(transaction: TransactionModel?) {
        
        guard let serviceID = transaction?.provider_service?.id,
              let cardID = transaction?.card_id?.id,
              let providerID = transaction?.provider_service?.providers?.id,
              let fields = transaction?.fields else { return }
        retryTransaction = .loading
        makeTransactionGetOtpUseCase.execute(
            request: .init(service_id: serviceID,
                           card_id: cardID,
                           provider_id: providerID,
                           fields: fields)
        ).sink { [weak self] baseResponse in
            guard let self = self else { return }
            switch baseResponse.status {
            case .success:
                self.retryTransaction = .success(baseResponse.response)
                break
            default:
                self.retryTransaction = .failure(.init(message: baseResponse.error))
                break
            }
            retryTransaction = .standart
        }.store(in: &bag)
        
    }
    
    public func makeTransactionVerifyOtp(otp: String?, verifyOtpData: TransactionOtpData?) {
        transactionVerifyOtp = .loading
        
        let request: MakeTransactionVerifyOtpRequest
        
        if Config.isDebug {
            request = MakeTransactionVerifyOtpRequest(session: verifyOtpData?.getSession(),
                                                      otp_code: otp,
                                                      transaction_id: verifyOtpData?.getTransactionId())
        } else {
            request = MakeTransactionVerifyOtpRequest(session: verifyOtpData?.getSession(),
                                                      otp_code: otp,
                                                      transaction_id: verifyOtpData?.getTransactionId())
        }
                                        
        makeTransactionVerifyOtpUseCase.execute(request: request)
            .sink { [weak self] baseResponse in
                guard let self else { return }
                switch baseResponse.status {
                case .success:
                    transactionVerifyOtp = .success(baseResponse.response)
                default:
                    transactionVerifyOtp = .failure(baseResponse.validationErrors)
                }
                transactionVerifyOtp = .standart
            }.store(in: &bag)
    }
}
