//
//  PaymentDropDownModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 20/02/23.
//

import Foundation
public protocol PaymentDropDownModel {
    var alias: String? { get }
    var title: String? { get }
}

public struct ExampleDropDownModel: PaymentDropDownModel {
    public var alias: String?
    
    public var title: String?
}
