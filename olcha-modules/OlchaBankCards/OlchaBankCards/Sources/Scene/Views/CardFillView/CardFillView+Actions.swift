import Foundation
import OlchaUI

//MARK: - Actions
public extension CardFillView {
    func sendPhoneCode() {
        let fields: [TField] = [cardNumberField, cardExpireField]
        let isFieldsValidated: Bool = fields.map({ $0.isValidated() }).allSatisfy({ $0 == true })
        
        guard isFieldsValidated, phoneNumberField.isValidated(isForced: !withPhone) else {
            return
        }
            
        let model = VerificationUploadCode(pan: cardNumberField.getText(),
                                           expiry: cardExpireField.getText(),
                                           phone: phoneNumberField.getPhone())
        observers?.sendCodeObserver.send(model)
    }
    
    func sendCard() {
        let fields: [TField] = [cardNumberField, cardExpireField, codeNumberField]
        let isFieldsValidated: Bool = fields.map({ $0.isValidated() }).allSatisfy({ $0 == true })

        guard isFieldsValidated, phoneNumberField.isValidated(isForced: !withPhone) else {
            return
        }
        let model = VerificationUploadBankCard(pan: cardNumberField.getText(),
                                               expiry: cardExpireField.getText(),
                                               phone: phoneNumberField.getPhone(),
                                               code: codeNumberField.getText())
        observers?.sendCardObserver.send(model)
        acceptButton.settings.requesting = true
    }
}
