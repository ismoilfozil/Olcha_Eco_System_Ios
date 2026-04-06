//
//  AddCardViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/02/23.
//

import UIKit
import OlchaUI
import AVFoundation
import Combine
public class AddCardViewController: BaseViewController<BackNavigationBar> {
    
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        return scrollView
    }()
    
    
    private lazy var cardNumberField: TField = {
        let field = TField()
        field.type = .cardNumber
        field.topHint = "card_number".localized()
        field.field_tag = (\AddCardOTPRequest.pan).propertyName
        return field
    }()
    
    private lazy var expiryDateField: TField = {
        let field = TField()
        field.type = .cardExpire
        field.topHint = "expire_to".localized()
        field.field_tag = (\AddCardOTPRequest.expiry).propertyName
        return field
    }()
    private lazy var nameField: TField = {
        let field = TField()
        field.type = .minLength(count: 2)
        field.topHint = "name".localized()
        field.field_tag = (\AddCardOTPRequest.cardName).propertyName
        return field
    }()
    
    private lazy var scanButton: IButton = {
        let button = IButton()
        button.titleLabel?.style(.medium, 16)
        button.setTitle("scan_with_camera".localized(), for: .normal)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.border(with: .olchaAccentColor, width: 1)
        button.round()
        return button
    }()
    
    private lazy var nextButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("next".localized())
        button.configure(type: .pay)
        return button
    }()
    
    weak var coordinator: AddCardCoordinatorProtocol?
    
    let cardModel = CardModel()
    
    let viewModel: CrudCardViewModel
    
    public override var validatedFields: [TField] {
        [
            cardNumberField,
            expiryDateField,
            nameField
        ]
    }
    
    public init(viewModel: CrudCardViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        
        scrollView.addArrangedSubview(cardNumberField)
        scrollView.addArrangedSubview(expiryDateField)
        
        
        scrollView.addArrangedSubview(scanButton)
        scrollView.addArrangedSubview(nameField)
        scrollView.addArrangedSubview(nextButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardNumberField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            
        }
        
        expiryDateField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        scanButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        nameField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        expiryDateField.widthOffset = 0.4
    }
    
    public override func configureViews() {
        navigationBar.setTitle("adding_card".localized())
        scrollView.container.setCustomSpacing(24, after: scanButton)
        nextButton.disableButton()
        scrollView.horizontalEdge(16)
    }
    
    public override func initialRequest() {
        //        cardModel.numbers = "8600312937900575"
        //        cardModel.expiry = "1225"
        //        cardModel.name = "elbek's card"
        //        verifyCard()
    }
    
    public override func setupObservers() {
        scanButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushScannerPage(cardModel: self.cardModel, delegate: self)
        }
        
        cardNumberField.observeText { [weak self] in
            guard let self = self else { return }
            self.cardModel.numbers = self.cardNumberField.getText()
            self.checkButtonState()
        }
        
        expiryDateField.observeText { [weak self] in
            guard let self = self else { return }
            self.cardModel.expiry = self.expiryDateField.getText()
            self.checkButtonState()
        }
        
        nameField.observeText { [weak self] in
            guard let self = self else { return }
            self.cardModel.name = self.nameField.getText()
            self.checkButtonState()
        }
        
        nextButton.clicked { [weak self] in
            guard let self = self else { return }
        
            self.verifyCard()
        }
        
        handle(viewModel.$addCardOTPData,
               success: { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.pushVerifyCode(cardModel: self.cardModel)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.nextButton.settings.requesting = isLoading
        })
        
    }
    
}

extension AddCardViewController: ScannerManagerDelegate {
    public func cardScannered(_ card: CardModel?) {
        cardNumberField.text = card?.numbers
        expiryDateField.text = card?.expiry
    
        checkButtonState()
    }
 
    private func checkButtonState() {
        var isEnabledButton: Bool = true
        if !cardNumberField.isValidated() {
            isEnabledButton = false
        }
        
        if !expiryDateField.isValidated() {
            isEnabledButton = false
        }
        
        if !nameField.isValidated() {
            isEnabledButton = false
        }
        
        isEnabledButton ? nextButton.enableButton() : nextButton.disableButton()
    }
}
