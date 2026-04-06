//
//  SimpleBuyModalPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 25/07/22.
//

import UIKit
import Combine
import OlchaUI
public class SimpleBuyModalPage: BaseViewController {
    
    public enum BuyType: Int {
        case oneClick = 0
        case preOrder = 1
    }
    
    private let productContainer = BasketProduct()
    private let separator = UIView()
    private let phoneField = TField()
    private let acceptButton = OlchaButton()
    
    private let privacyCheckBox = IconButton()
    private let privacyTitle = UILabel()
    private let privacySubtitle = UILabel()
    
    var type: BuyType = .preOrder
    
    var product: ProductModel?
    
    var isChecked = false {
        didSet {
            privacyCheckBox.setIcon(isChecked ? .checked : .unchecked)
            checkButtonState()
        }
    }
    
    private let viewModel = CheckoutViewModel()
    private var bag = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        if type == .oneClick {
            configureModalViews(header: "order_one_click".localized())
        } else {
            configureModalViews(header: "preOrder".localized())
        }
        setupObservers()
        
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(productContainer)
        
        productContainer.addSubview(separator)
        modalContainer.addSubview(phoneField)
        
        modalContainer.addSubview(privacyCheckBox)
        modalContainer.addSubview(privacyTitle)
        modalContainer.addSubview(privacySubtitle)
        
        modalContainer.addSubview(acceptButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        staticLayouts()
    }
    
    private func staticLayouts() {
        productContainer.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(productContainer.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
        
        phoneField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).inset(-16)
        }
        
        privacyCheckBox.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).inset(-16)
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        privacyTitle.snp.makeConstraints { make in
            make.left.equalTo(privacyCheckBox.snp.right).inset(-8)
            make.top.equalTo(privacyCheckBox.snp.top)
            make.right.equalToSuperview().inset(16)
        }
        
        privacySubtitle.snp.makeConstraints { make in
            make.left.equalTo(privacyCheckBox.snp.right).inset(-8)
            make.top.equalTo(privacyTitle.snp.bottom).inset(-2)
            make.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(privacySubtitle.snp.bottom).inset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: header, textAlignment: textAlignment)
        dismissConfiguration()
        productContainer.backgroundColor = .clear
        
        separator.backgroundColor = .olchaLightNeutralGray
        acceptButton.setTitle("checkout".localized())
        
        phoneField.placeholder = .phonePlaceholder
        phoneField.topHint = "contact_number".localized()
        phoneField.type = .shortPhone
        
        privacyTitle.text = "agree".localized()
        privacyTitle.style(.medium, 14)
        privacyTitle.textColor = .olchaTextBlack
        
        privacySubtitle.text = "agree_subtitle".localized()
        privacySubtitle.style(.medium, 14)
        privacySubtitle.textColor = .olchaLightTextColornnnnnn
        privacySubtitle.numberOfLines = 0
        privacyCheckBox.setIcon(.unchecked)
        
        fillWithData()
        isChecked = false
    }
    
    private func fillWithData() {
        productContainer.setup(with: self.product)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        super.setupObservers()
        privacyCheckBox.clicked { [weak self] in
            guard let self = self else { return }
            self.isChecked = !self.isChecked
        }
        
        acceptButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            if self.isChecked {
                guard let id = self.product?.id else { return }
                
                self.acceptButton.settings.requesting = true
                self.viewModel.simpleBuy(productID: id,
                                         type: self.type,
                                         phone: self.phoneField.getPhone())
            }
        }
        
        viewModel
            .$orderedSuccessFully
            .sink { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.showOrderSuccess(type: .simple,
                                          homeObserver: {},
                                          actionObserver: {
                        self.dismiss(animated: true)
                    })
                }
                
                self.acceptButton.settings.requesting = false
            }.store(in: &bag)
        
        viewModel
            .simpleBuyIndicator
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.acceptButton.settings.requesting = isLoading
            }.store(in: &bag)
        
        phoneField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
    }
    
    private func checkButtonState() {
        
        if isChecked && phoneField.isValidated() {
            acceptButton.enableButton()
        } else {
            acceptButton.disableButton()
        }
    }
    
    
}
