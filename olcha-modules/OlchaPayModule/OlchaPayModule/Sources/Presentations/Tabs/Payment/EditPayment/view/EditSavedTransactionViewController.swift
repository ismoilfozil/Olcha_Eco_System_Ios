//
//  SavePaymentViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 23/02/23.
//

import UIKit
import OlchaUI


public class EditTransactionViewController: BaseViewController<BackNavigationBar> {

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
    
    public var transaction: SavedTransactionModel? {
        didSet {
            nameField.text = transaction?.name
            checkButtonState()
        }
    }
    
    let viewModel: SavedTransactionsViewModel
    
    var id: Int?
    
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
            self.acceptButtonAction()
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

        handle(viewModel.$savedTransaction,
               showLoader: true) { [weak self] data in
            guard let self = self else { return }
            self.transaction = data?.saved_transactions
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        }

    }
    
    public override func initialRequest() {
        checkButtonState()
        
        viewModel.loadSavedTransaction(id: id)
    }
    
    private func checkButtonState() {
        (nameField.getText() == "") ? saveButton.disableButton() : saveButton.enableButton()
    }
    
    private func acceptButtonAction()  {
        getTransaction { [weak self] model in
            guard let self = self,
                  let id = self.id,
                  let transaction = self.transaction else { return }
            self.viewModel.editTransaction(id: id,
                                           name: self.nameField.getText(),
                                           transaction: transaction)
        }
    }
    
    public func getTransaction(completion: @escaping ((SavedTransactionModel?) -> Void) ) {
        if let transaction = transaction {
            completion(transaction)
        } else {
            viewModel.loadSavedTransaction(id: id) { [weak self] in
                guard let self = self else { return }
                completion(self.transaction)
            }
        }
    }
}

