import Foundation

//MARK: - States
public extension CardFillView {

    func buttonResend() {
        
        stopTimer()
    }
    
    func isFilled() {
        checkButtonState()
        
        
        let cardNumberErrorMessage = cardNumberField.currentMeesage()
        let cardExpireErrorMessage = cardExpireField.currentMeesage()
        
        if cardNumberErrorMessage == nil && cardExpireErrorMessage == nil {
            
            cardNumberField.defaultStyle()
            cardExpireField.defaultStyle()
            
            
        } else {
            cardNumberField.errorStyle((cardNumberErrorMessage ?? (cardExpireErrorMessage ?? " ")))
            cardExpireField.errorStyle(" ")
        }
    }
    
    func codeOpened() {
        codeFieldContainer.isHidden = false
    }
    
    func codeClosed() {
        codeFieldContainer.isHidden = true
    }
    
    func checkStates() {
        state = .phone
        isFilled()
        buttonResend()
        codeClosed()
    }
    
    func checkButtonState() {
        var isValidated = true
        
        if !cardNumberField.isValidated(withMessage: false) {
            isValidated = false
        }
        
        if !cardExpireField.isValidated(withMessage: false) {
            isValidated = false
        }
        
        if !phoneNumberField.isValidated(withMessage: !withPhone) {
            isValidated = false
        }
        
        if (state == .code) && !codeNumberField.isValidated(withMessage: false) {
            isValidated = false
        }
    
        isValidated ? acceptButton.enableButton() : acceptButton.disableButton()
    }
    
    func discard() {
        acceptButton.settings.requesting = false
        phoneNumberField.settings.text = ""
        cardNumberField.settings.text = ""
        cardExpireField.settings.text = ""
        codeNumberField.settings.text = ""
        checkStates()
    }
}
