//
//  TextFieldRules+Extension.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 02/06/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaUI

public extension TextFieldRules {
    static func profitAmountRule() -> TextFieldValidationRule {
        return { text in
            let number = text.withoutSpace
            guard !number.isEmpty else {
                return .invalid("enter_amount".localized())
            }
            return number.double > 0 ? .valid : .invalid("incorrect_amount".localized())
        }
    }
    
    static func investAmountRule(min: Double) -> TextFieldValidationRule {
        return { text in
            let format = "enter_more_than_min_amount".localized(.olchaInvestCore)
            let error = String(format: format, min.string.originalPriceWithoutCurrency)
            let number = text.withoutSpace
            guard !number.isEmpty else {
                return .invalid(error)
            }
            return number.double >= min ? .valid : .invalid(error)
        }
    }
    
    static func maxAmountRule(max: Double) -> TextFieldValidationRule {
        return { text in
            let maxFormat = "enter_more_than_max_amount".localized(.olchaInvestCore)
            let maxError = String(format: maxFormat, max.string.originalPriceWithoutCurrency)
            let number = text.withoutSpace
            guard number.double <= max else {
                return .invalid(maxError)
            }
            return number.double <= max ? .valid : .invalid(maxError)
        }
    }
}
