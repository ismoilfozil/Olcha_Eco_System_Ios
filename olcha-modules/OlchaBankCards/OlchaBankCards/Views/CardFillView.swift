//
//  CardFillView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//

import Foundation
import UIKit
import Combine
import OlchaUI
import IQKeyboardManagerSwift

public class CardFillObservers {
    
    public init() {}
    
    public let stateObserver = PassthroughSubject<Bool, Never>()
    public let sendCodeObserver = PassthroughSubject<VerificationUploadCode, Never>()
    public let sendCardObserver = PassthroughSubject<VerificationUploadBankCard, Never>()
    public let codeSentObserver = PassthroughSubject<Bool, Never>()
    public let requestFinished = PassthroughSubject<Bool, Never>()
}

public class CardFillView: UIView {
    
    public enum ViewState {
        case phone
        case code
    }
    
    private var bag = Set<AnyCancellable>()
    
    private let container = UIStackView()
    
    private let cardContainer = UIView()
    private var timer: Timer?
    private var timerSeconds = 0
    let timeLabel = UILabel()
    let sendButton = IButton()
    
    let cardNumberField = TField()
    let cardExpireField = TField()
    let phoneNumberField = TField()
    
    let codeFieldContainer = UIView()
    let codeNumberField = TField()
    
    let acceptButton = OlchaButton()
    
    public var state: ViewState = .phone {
        didSet {
            (state == .code) ? codeOpened() : codeClosed()
        }
    }
    
    public weak var observers: CardFillObservers? {
        didSet {
            setupOptionalObservers()
        }
    }
    
    public var withPhone: Bool = true {
        didSet {
            phoneNumberField.isHidden = !withPhone
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
        setupObservers()
    }
    
    private func setupViews() {
        addSubview(container)
        
        container.addArrangedSubview(cardContainer)
        
        cardContainer.addSubview(cardNumberField)
        cardContainer.addSubview(cardExpireField)
        
        container.addArrangedSubview(phoneNumberField)
        container.addArrangedSubview(codeFieldContainer)
        
        
        codeFieldContainer.addSubview(codeNumberField)
        codeFieldContainer.addSubview(timeLabel)
        codeFieldContainer.addSubview(sendButton)
        
        container.addArrangedSubview(acceptButton)
    }
    
    private func autolayout() {

        container.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        cardNumberField.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        cardExpireField.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(cardNumberField.snp.right).inset(-4)
            make.bottom.equalTo(cardNumberField.snp.bottom)
            make.width.equalTo(100)
        }
        
        phoneNumberField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        codeNumberField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(codeNumberField.snp.bottom).inset(-4)
            make.left.equalTo(codeNumberField.snp.left)
            make.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(codeNumberField.snp.bottom)
            make.right.equalTo(codeNumberField.snp.right)
            make.bottom.equalToSuperview()
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func configureViews() {
        container.axis = .vertical
        container.spacing = 16
        cardNumberField.placeholder = "0000 0000 0000 0000"
        cardNumberField.topHint = "card_number".localized()
        cardExpireField.placeholder = "04/24".localized()
        
        
        phoneNumberField.topHint = "phone_number".localized()
        phoneNumberField.type = .shortPhone
        phoneNumberField.placeholder = .phonePlaceholder
        
        codeNumberField.topHint = "code".localized()
        codeNumberField.placeholder = "0000"
        
        timeLabel.style(.regular, 13)
        timeLabel.textColor = .olchaTextBlack
        timeLabel.text = ""
        
        sendButton.setTitleColor(.olchaAccentColor, for: .normal)
        sendButton.titleLabel?.style(.regular, 13)
        sendButton.setTitle("resend_code".localized(), for: .normal)

        
        cardNumberField.type = .cardNumber
        cardExpireField.type = .cardExpire
        cardExpireField.canUseRules = false
        cardNumberField.canUseRules = false
        
        acceptButton.setTitle("continue".localized())
        
        checkStates()
    }
    
    private func setupObservers() {
        cardNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        cardExpireField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        phoneNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        
        sendButton.clicked { [weak self] in
            guard let self = self else { return }
            if self.timerSeconds == 0 {
                self.sendPhoneCode()
            }
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }

            switch self.state {
            case .phone:
                self.acceptButton.settings.requesting = true
                self.sendPhoneCode()
                break
            case .code:
                self.sendCard()
                break
            }
        }
        
        
    }
    
    public func setupOptionalObservers() {
        observers?.codeSentObserver.sink { [weak self] isSent in
            guard let self = self else { return }
            
            self.observers?.stateObserver.send(true)
            isSent ? self.codeOpened() : self.codeClosed()
            if isSent {
                self.state = .code
                self.startTimer()
            }
        }.store(in: &bag)
        
        observers?.requestFinished.sink { [weak self] isFinished in
            guard let self = self, isFinished else { return }
            self.acceptButton.settings.requesting = false
        }.store(in: &bag)
    }


}

//MARK: - Timer
extension CardFillView {
    
    private func startTimer() {
        timer?.invalidate()
        timer = nil
        
        sendButton.isHidden = true
        timeLabel.isHidden = false
        timerSeconds = 60
        countdown()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        sendButton.isHidden = false
        timeLabel.isHidden = true
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func countdown() {
        timerSeconds -= 1
        
        if timerSeconds == 0 {
            buttonResend()
        }
        
        let minutes = (timerSeconds % 3600) / 60
        let seconds = (timerSeconds % 3600) % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: - States
extension CardFillView {

    private func buttonResend() {
        
        stopTimer()
    }
    
    private func isFilled() {
        let numbersValidated = cardNumberField.isValidated(withMessage: false) && cardExpireField.isValidated(withMessage: false)
        
        if numbersValidated && phoneNumberField.isValidated(isForced: !withPhone) {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
        
        
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
    
    private func codeOpened() {
        codeFieldContainer.isHidden = false
    }
    
    private func codeClosed() {
        codeFieldContainer.isHidden = true
    }
    
    public func checkStates() {
        state = .phone
        isFilled()
        buttonResend()
        codeClosed()
    }
    
    public func discard() {
        acceptButton.settings.requesting = false
        phoneNumberField.settings.text = ""
        cardNumberField.settings.text = ""
        cardExpireField.settings.text = ""
        codeNumberField.settings.text = ""
        checkStates()
    }
}

//MARK: - Actions
extension CardFillView {
    private func sendPhoneCode() {
        if cardNumberField.isValidated() && cardExpireField.isValidated() && phoneNumberField.isValidated(isForced: !withPhone) {
            
            let model = VerificationUploadCode(pan: cardNumberField.getText(),
                                               expiry: cardExpireField.getText(),
                                               phone: phoneNumberField.getPhone())
            observers?.sendCodeObserver.send(model)
            
        }
        
    }
    
    private func sendCard() {
        
        if cardNumberField.isValidated() && cardExpireField.isValidated() && phoneNumberField.isValidated(isForced: !withPhone) && codeNumberField.isValidated() {
            let model = VerificationUploadBankCard(pan: cardNumberField.getText(),
                                                   expiry: cardExpireField.getText(),
                                                   phone: phoneNumberField.getPhone(),
                                                   code: codeNumberField.getText())
            observers?.sendCardObserver.send(model)
            acceptButton.settings.requesting = true
        }
    }
}
