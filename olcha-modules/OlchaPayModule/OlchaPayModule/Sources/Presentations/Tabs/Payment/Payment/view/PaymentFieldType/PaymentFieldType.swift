//
//  PaymentModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 20/02/23.
//

import Foundation
import OlchaUI
import OlchaCore
public enum PaymentType {
    case input(PaymentFieldModel)
    case select(PaymentSelectModel)
}

public class PaymentFieldModel {
    var type: TFieldType
    var topHint: String?
    var placeholder: String?
    var key: String?
    var serviceType: String?
    var value: String?
    
    public init(key: String?,
                type: TFieldType,
                topHint: String?,
                placeholder: String?,
                serviceType: String?,
                value: String? = nil
    ) {
        self.key = key
        self.type = type
        self.topHint = topHint
        self.placeholder = placeholder
        self.serviceType = serviceType
        self.value = value
    }
    
    func getServiceType() -> ServiceFieldType {
        guard let serviceType = serviceType,
              let resultServiceType = ServiceFieldType(rawValue: serviceType)
        else { return .none }
        
        return resultServiceType
    }
}

public class PaymentSelectModel {
    var key: String?
    var topHint: String?
    var items: [ServiceFieldValue]?
    var value: String?
    var type: TFieldType?
    var parentID: String?
    var serviceType: String?
    var id: String?
    
    public init(key: String?,
                type: TFieldType?,
                topHint: String?,
                items: [ServiceFieldValue]?,
                parentID: String?,
                serviceType: String?,
                id: String?,
                value: String? = nil
    ) {
        self.key = key
        self.type = type
        self.topHint = topHint
        self.items = items
        self.serviceType = serviceType
        self.parentID = parentID
        self.id = id
        self.value = value
    }
    
    func getServiceType() -> ServiceFieldType {
        guard let serviceType = serviceType,
              let resultServiceType = ServiceFieldType(rawValue: serviceType)
        else { return .none }
        
        return resultServiceType
    }
}

public protocol PaymentFieldProtocol: AnyObject {
    var actionObserver: ((String?) -> Void)? { get set }
    var valueUpdatedObserver: ((String?) -> Void)? { get set }
    var isValidated: Bool { get }
    var field: TField { get }
    func getId() -> String?
    func getValue() -> String?
    func getKey() -> String?
    func getParentKey() -> String?
    func getServiceType() -> ServiceFieldType?
    func getType() -> String?
    func setValue(value: String?)
}
