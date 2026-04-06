//
//  TransactionAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 28/03/23.
//

import Foundation
import OlchaCore
public enum TransactionAPI {
    case transactions(filters: TransactionsFilters)
    case transaction(id: Int)
    case features
    case makeTransactionGetOtp(request: MakeTransactionGetOtpRequest)
    case makeTransactionVerifyOtp(request: MakeTransactionVerifyOtpRequest)
}

extension TransactionAPI: BaseOlchaPayApi {
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .transactions(let filters):
            
            var queryItems: [URLQueryItem] = []
            
            queryItems.append(.init(name: "page", value: filters.paging.current.string))
                        
            if let categoryID = filters.categoryID {
                queryItems.append(.init(name: "provider_service__providers__category", value: categoryID.string))
            }
            
            if let cardType = filters.cardType {
                queryItems.append(.init(name: "card_id__bank_card__type", value: cardType))
            }
            
            if let cardID = filters.cardID {
                queryItems.append(.init(name: "card_id", value: cardID.string))
            }
                                  
            if let from = filters.from {
                queryItems.append(.init(name: "created_at_after", value: from))
            }
                                  
            if let to = filters.to {
                queryItems.append(.init(name: "created_at_before", value: to))
            }
                                  
            
            return queryItems
        default:
            return []
        }
    }
    
    public var path: String {
        switch self {
        case .features:
            return "transactions/filter/"
        case .transactions:
            return "transactions/transaction_list/"
        case .transaction(let id):
            return "transactions/transaction/\(id)/"
        case .makeTransactionGetOtp:
            return "transactions/send_otp/"
        case .makeTransactionVerifyOtp:
            return "transactions/confirm/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .features:
            return .get
        case .transactions:
            return .get
        case .transaction:
            return .get
        case .makeTransactionGetOtp:
            return .post
        case.makeTransactionVerifyOtp:
            return .post
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
        case .makeTransactionGetOtp(let request):
            data = encode(request)
        case .makeTransactionVerifyOtp(let request):
            data = encode(request)
        default:
            break
        }
        return data
    }
    
    
}
