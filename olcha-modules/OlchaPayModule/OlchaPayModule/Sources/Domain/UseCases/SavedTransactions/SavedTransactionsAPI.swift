//
//  SavedTransactionsAPI.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import Foundation
import OlchaCore
public enum SavedTransactionsAPI {
    case savedTransaction(id: Int)
    
    case savedTransactions(page: Int)
    
    case saveTransaction(request: SaveTransactionRequest)
    
    case editTransaction(id: Int, request: SaveTransactionRequest)
    
    case deleteTransaction(id: Int)

}

extension SavedTransactionsAPI: BaseOlchaPayApi {
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .savedTransactions(let page):
            return [
                .init(name: "page", value: page.string)
            ]
        default:
            return []
        }
    }
    
    public var path: String {
        switch self {

        case .savedTransaction(let id):
            return "transactions/saved_transactions/\(id)/"
            
        case .savedTransactions:
            return "transactions/saved_transactions/"

        case .saveTransaction:
            return "transactions/saved_transactions/"

        case .deleteTransaction(let id):
            return "transactions/saved_transactions/\(id)/"

        case .editTransaction(let id, _):
            return "transactions/saved_transactions/\(id)/"
        }
    }
    
    public var method: RequestType {
        switch self {
        case .savedTransaction:
            return .get
        case .savedTransactions:
            return .get
        case .saveTransaction:
            return .post
        case .deleteTransaction:
            return .delete
        case .editTransaction:
            return .put
        }
    }
    
    public var body: Data? {
        var data: Data?
        switch self {
        case .saveTransaction(let request):
            data = encode(request)
            break
        case .editTransaction(_ , let request):
            data = encode(request)
            break
        default:
            break
        }
        return data
    }
    
    
}
