//
//  CardFillView.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//

import UIKit
import Combine
import OlchaUI

public class CardFillView: UIView {
    
    public enum ViewState {
        case phone
        case code
    }
    
    private var bag = Set<AnyCancellable>()
    
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    private let cardContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        return stackView
    }()
    public var timer: Timer?
    public var timerSeconds = 0
    public let timeLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 13)
        label.textColor = .olchaTextBlack
        label.text = ""
        return label
    }()
    public let sendButton: IButton = {
        let button = IButton()
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.titleLabel?.style(.regular, 13)
        button.setTitle("resend_code".localized(), for: .normal)
        return button
    }()
    public let cardNumberField: TField = {
        let field = TField()
        field.placeholder = "0000 0000 0000 0000"
        field.topHint = "card_number".localized()
        field.type = .cardNumber
        field.canUseRules = false
        return field
    }()
    public let cardExpireField: TField = {
        let field = TField()
        field.placeholder = "04/24".localized()
        field.topHint = "\t"
        field.type = .cardExpire
        field.canUseRules = false
        return field
    }()
    public let phoneNumberField: TField = {
        let field = TField()
        field.topHint = "phone_number".localized()
        field.type = .shortPhone
        field.placeholder = .phonePlaceholder
        return field
    }()
    public let codeFieldContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()
    public let codeNumberField: TField = {
        let field = TField()
        field.topHint = "code".localized()
        field.placeholder = "0000"
        field.type = .required
        field.canUseRules = false
        return field
    }()
    public let acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("continue".localized())
        return button
    }()
    
    public lazy var fields: [TField] = [
        cardNumberField,
        cardExpireField,
        phoneNumberField,
        codeNumberField
    ]
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        bag.forEach({ $0.cancel() })
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

        checkStates()
    }
    
    private func setupObservers() {
        cardNumberField.observeTextChanged { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        cardExpireField.observeTextChanged { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        phoneNumberField.observeTextChanged { [weak self] in
            guard let self = self else { return }
            self.checkStates()
        }
        
        codeNumberField.observeTextChanged { [weak self] in
            guard let self else { return }
            isFilled()
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
