//
//  SearchOrderPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 26/12/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaAuth
class SearchOrderPage: BaseViewController {
    
    private var bag = Set<AnyCancellable>()
    
    private let containerStackView = UIStackView()
    
    private let phoneField = TField()
    
    private let orderIdField = TField()
    
    private let searchButton = OlchaButton()
    
    private let subtitleLabel = UILabel()
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    private let viewModel = OrderPageViewModel()
    
    override func setupViews() {
        container.addSubview(containerStackView)
        containerStackView.addArrangedSubview(phoneField)
        containerStackView.addArrangedSubview(orderIdField)
        containerStackView.addArrangedSubview(searchButton)
        containerStackView.addArrangedSubview(subtitleLabel)
    }
    
    override func autolayout() {
        containerStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        searchButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        phoneField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        orderIdField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigation.setTitle("follow_order".localized())
        navigation.configure(style: .back)
        
        containerStackView.alignment = .firstBaseline
        containerStackView.distribution = .fill
        containerStackView.axis = .vertical
        containerStackView.spacing = 16
        
        phoneField.type = .shortPhone
        orderIdField.placeholder = "number_order".localized()
        orderIdField.settings.keyboardType = .numberPad
        searchButton.setTitle("follow".localized())
        
        
        subtitleLabel.style(.medium, 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .olchaLightTextColornnnnnn
        subtitleLabel.text = "number_order_sent".localized()
        checkButtonState()
        

    }
    
    override func initialRequest() {
        if AuthGlobalDefaults.isUser() {
            phoneField.setPhone(number: AuthGlobalDefaults.user.phone)
        }
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        phoneField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        orderIdField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        searchButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.searchOrder(
                phone: self.phoneField.getPhone(),
                orderID: self.orderIdField.getText())
        }
        
        viewModel
            .$order
            .sink { [weak self] data in
                guard let self = self,
                      let data = data else { return }
                self.coordinator?.pushFoundOrder(order: data)
            }.store(in: &bag)
        
        viewModel
            .orderSearchRequesting
            .sink { [weak self] isSearching in
                guard let self = self else { return }
                self.searchButton.settings.requesting = isSearching
                self.checkButtonState()
            }.store(in: &bag)
    }
    
    private func checkButtonState() {
        var isEnbled = true
        
        if orderIdField.getText() == "" {
            isEnbled = false
        }
        
        if !AuthGlobalDefaults.isUser() && !phoneField.isValidated() {
            isEnbled = false
        }
        
        isEnbled ? searchButton.enableButton() : searchButton.disableButton()
    }
}
