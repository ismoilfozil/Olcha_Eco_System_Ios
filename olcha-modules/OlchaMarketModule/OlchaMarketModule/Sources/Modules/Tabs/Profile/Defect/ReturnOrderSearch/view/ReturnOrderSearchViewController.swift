//
//  ReturnOrderViewController.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 17/10/23.
//

import UIKit
import OlchaUI

public class ReturnOrderSearchViewController: OlchaUI.BaseViewController<OlchaUI.BackNavigationBar> {
    
    private let orderField: TField = {
        let field = TField()
        field.type = .number
        return field
    }()
    
    private let acceptButton = OlchaButton()
    
    let viewModel = OrderPageViewModel()
    
    weak var coordinator: ReturnOrderCoordinatorProtocol?
    
    public override func setupViews() {
        container.addSubview(orderField)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        orderField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(orderField.snp.bottom).inset(-16)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
        acceptButton.disableButton()
//        orderField.setValue(string: "484393")
    }
    
    public override func setupObservers() {
        orderField.observeText { [weak self] in
            guard let self else { return }
            orderField.isValidated() ? acceptButton.enableButton() : acceptButton.disableButton()
        }
        
        acceptButton.clicked { [weak self] in
            guard let self else { return }
            viewModel.searchReturnOrder(orderID: orderField.getValue().int)
        }
        
        handle(viewModel.$orderReturnSearch, withError: false) { [weak self] data in
            guard let self = self else { return }
            coordinator?.pushReturnOrderProducts(order: data?.order)
        } failure: { [weak self] error in
            guard let self = self else { return }
            orderField.errorStyle(error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            acceptButton.settings.requesting = isLoading
        }
    }
    
    public override func languageUpdated() {
        orderField.topHint = "number_order".localized()
        acceptButton.setTitle("search".localized())
        navigationBar.setTitle("return_defect_products".localized())
    }
    
}
