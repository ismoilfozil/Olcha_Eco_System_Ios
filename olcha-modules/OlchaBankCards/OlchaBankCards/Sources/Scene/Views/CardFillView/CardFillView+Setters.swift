import Foundation

public extension CardFillView {
    func setupCardNumberField(title: String) {
        cardNumberField.field_tag = title
    }
    
    func setupCardExpireField(title: String) {
        cardExpireField.field_tag = title
    }
    
    func setupPhoneNumberField(title: String) {
        phoneNumberField.field_tag = title
    }
    
    func setupCodeNumberField(title: String) {
        codeNumberField.field_tag = title
    }
}
