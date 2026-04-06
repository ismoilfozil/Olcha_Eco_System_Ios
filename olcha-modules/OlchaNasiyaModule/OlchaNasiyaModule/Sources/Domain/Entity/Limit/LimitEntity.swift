//
//  LimitEntity.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/06/23.
//

import Foundation
public struct LimitModel: Codable {
    public var limit: InstallmentLimitBalanceData?
    public var message: String?
}
public struct InstallmentLimitBalanceData: Codable {
    public var remaining_percent: Int?
    public var limit_amount: Double?
    public var installment_limit_balance: InstallmentLimitBalanceModel?
    public var request_status: RequestStatusModel?
    public var message: String?
}

public struct InstallmentLimitBalanceModel: Codable {
    public var id: Int?
    public var type: String?
    public var amount: Double?
    public var created_at: String?
    
    public enum Status: String {
        case rejected
        case approved
        case none
    }
    
    public func getType() -> Status {
        if let type {
            return Status(rawValue: type) ?? .none
        } else {
            return .none
        }
    }
}

public struct RequestStatusModel: Codable {
    
    public enum Status: String {
        case rejected
        case approved
        case requested
        case none
    }
    
    public var status: String?
    public var created_at: String?
    
    public func getStatus() -> Status {
        if let status {
            return Status(rawValue: status) ?? .none
        } else {
            return .none
        }
    }
}
