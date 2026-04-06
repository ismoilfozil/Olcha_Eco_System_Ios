//
//  TextFieldRules.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 04/04/23.
//
import OlchaUtils
import Foundation
public class TextFieldRules {
    
    nonisolated(unsafe) public static let shared = TextFieldRules()
    
    public init() {}
    
    public let requiredRule: TextFieldValidationRule = { text in
        if text.isEmpty || text.replacingOccurrences(of: " ", with: "").isEmpty {
            return .invalid("empty".localized())
        }
        
        return .valid
    }
    
    public let fullPhoneRule: TextFieldValidationRule = { text in
        if text.phoneNumber.count == "998970027188".count {
            return .valid
        } else {
            return .invalid("phone_number_error".localized())
        }
    }
    
    public let shortPhoneRule: TextFieldValidationRule = { text in
        if text.phoneNumber.count == "970027188".count {
            return .valid
        } else {
            return .invalid("phone_number_error".localized())
        }
    }
    
    public let cardNumberRule: TextFieldValidationRule = { text in
        if text.phoneNumber.count == "0000_0000_0000_0000".replacingOccurrences(of: "_", with: "").count {
            return .valid
        } else {
            return .invalid("card_number_error".localized())
        }
    }
    
    public let cardExpireRule: TextFieldValidationRule = { text in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"

        guard let date = dateFormatter.date(from: text) else {
            return .invalid("card_expire_error".localized())
        }
        
        let currentDate = Date()
        guard let maxDate = Calendar.current.date(byAdding: .year, value: 6, to: currentDate) else {
            return .invalid("card_expire_error".localized())
        }
        
        guard let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: date) else {
            return .invalid("card_expire_error".localized())
        }
        
        if endOfMonth < currentDate || date > maxDate {
            return .invalid("card_expire_error".localized())
        }

        return .valid
    }

    
    public let passwordRule: TextFieldValidationRule = { text in
        let validationCount = 6
        if text.count >= validationCount {
            return .valid
        } else {
            return .invalid("empty_count".localized() + " " + validationCount.string)
        }
    }
    
    public func amountRule(min: Double = 0, max: Double? = nil, currency: String? = nil, zeroEnabled: Bool = false) -> TextFieldValidationRule {
        let amountRule: TextFieldValidationRule = { text in
            
            let amount = text.phoneNumber.double
            let currencyText = currency ?? Texts.currency
            
            let defaultInvalidError: String = .lang(
                "Сумма должно быть больше \(min.int) \(currencyText)",
                "Сумма \(min.int) \(currencyText)дан катта бўлиши керак",
                "Summa \(min.int) \(currencyText)dan katta bo'lishi kerak"
            )
            
            let zeroCheck = zeroEnabled ? true : (amount > 0)
            
            let defaultInvalidCheck: ValidationResult = (amount >= min && zeroCheck) ? .valid : .invalid(defaultInvalidError)
            
            guard let max = max else {
                return defaultInvalidCheck
            }
            guard min < max else {
                return defaultInvalidCheck
            }
            
            let closedRange: ClosedRange<Double> = min...max
            guard closedRange.lowerBound != closedRange.upperBound else { return .valid }
            
            
            if closedRange.contains(amount) {
                return .valid
            }
            
            return .invalid(
                .lang("Сумма должно быть между: \(closedRange.lowerBound.string.originalPriceWithoutCurrency + currencyText) - \(closedRange.upperBound.string.originalPriceWithoutCurrency + currencyText)",
                      
                      "Сумма орасида бўлиши керак: \(closedRange.lowerBound.string.originalPrice) - \(closedRange.upperBound.string.originalPriceWithoutCurrency + currencyText)",
                      
                      "Summa orasida bo'lishi kerak: \(closedRange.lowerBound.string.originalPriceWithoutCurrency + currencyText) - \(closedRange.upperBound.string.originalPriceWithoutCurrency + currencyText)")
            )
        }
        return amountRule
    }
    
    public func maxCashRule(max: Double? = nil, currency: String? = nil, errorMessage: String = "cash_not_enough".localized()) -> TextFieldValidationRule {
        let amountRule: TextFieldValidationRule = { text in
            
            let amount = text.phoneNumber.double
            let currencyText = currency ?? Texts.currency
            
            let invalidCheck: ValidationResult = (amount <= (max ?? amount)) ? .valid : .invalid(errorMessage)
            
            return invalidCheck
        }
        return amountRule
    }
    
    public func regexRule(pattern: String?) -> TextFieldValidationRule {
        
        let regexRule: TextFieldValidationRule = { text in
            
            let isValidated = text.validateText(pattern: pattern)
            return isValidated ? .valid : .invalid("regex_validation".localized())
        }
        
        return regexRule
    }
    
    public func minLengthRule(count: Int) -> TextFieldValidationRule {
        
        let minLengthRule: TextFieldValidationRule = { text in
            let isValidated = (text.withoutWhiteSpace.count > count)
            return isValidated ? .valid : .invalid("min_length_validation".localized() + " - " + (count + 1).string)
        }
        
        return minLengthRule
    }
}
