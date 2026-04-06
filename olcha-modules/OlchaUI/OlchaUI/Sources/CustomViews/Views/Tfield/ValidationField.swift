//
//  ValidationField.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 04/04/23.
//

import UIKit
public enum ValidationFieldType {
    case fullPhone
    case shortPhone
    case phone
    case amount(range: ClosedRange<Double>)
    case cardNumber
    case `default`
}

public class ValidationField: TField {
    
    
    
}
