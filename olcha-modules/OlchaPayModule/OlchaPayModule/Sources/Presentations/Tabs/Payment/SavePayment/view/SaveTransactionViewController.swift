//
//  SavePaymentViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI

public class SaveTransactionViewController: BaseViewController<BackNavigationBar> {

    private lazy var nameField: TField = {
        let field = TField()
        field.topHint = "named".localized()
        return field
    }()
    
    private lazy var saveButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("save".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public weak var coordinator: PaymentsCoordinatorProtocol?
    
    public var transaction: TransactionModel?
    
    let viewModel: SavedTransactionsViewModel
    
    public init(viewModel: SavedTransactionsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(nameField)
        container.addSubview(saveButton)
    }
    
    public override func autolayout() {
        nameField.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameField.snp.bottom).inset(-40)
        }
    }

    public override func configureViews() {
        navigationBar.setTitle("payment_name".localized())
    }
    
    public override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self = self else { return }
            self.viewModel.saveTransaction(name: self.nameField.getText(),
                                           transaction: self.transaction)
        }
        
        nameField.observeText { [weak self] in
            guard let self = self else { return }
            self.checkButtonState()
        }
        
        handle(viewModel.$saveTransaction) { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.pushSaveTransactionFinished()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.saveButton.settings.requesting = isLoading
        }

    }
    
    public override func initialRequest() {
        checkButtonState()
    }
    
    private func checkButtonState() {
        (nameField.getText() == "") ? saveButton.disableButton() : saveButton.enableButton()
    }

}
