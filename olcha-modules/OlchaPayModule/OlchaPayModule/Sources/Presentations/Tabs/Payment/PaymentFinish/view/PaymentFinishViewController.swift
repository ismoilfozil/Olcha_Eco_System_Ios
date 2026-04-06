//
//  PaymentFinishViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 21/02/23.
//

import UIKit
import OlchaUI
public class PaymentFinishViewController: BaseViewController<EmptyNavigationBar> {

    lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.alignment = .center
        scrollView.container.spacing = 24
        scrollView.settings.contentInset = .init(top: 60, left: 0, bottom: 24, right: 0)
        return scrollView
    }()
    
    lazy var finishIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .payment_finish
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 24)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        label.text = "payment_success".localized()
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaDarkGray
        label.textAlignment = .center
        label.text = " - "
        return label
    }()
    
    lazy var backButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("close".localized())
        button.configure(type: .pay)
        return button
    }()
    
    lazy var detailStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var actionsContainer: FinishActionsView = {
        let view = FinishActionsView()
        return view
    }()
    
    public weak var coordinator: PaymentsCoordinatorProtocol?
    
    public var fullTransaction: TransactionModel?
    
    public var transaction: TransactionModel?
    
    let transactionViewModel: TransactionViewModel
    let makeTransactionViewModel: MakeTransactionViewModel
    
    public init(transactionViewModel: TransactionViewModel,
                makeTransactionViewModel: MakeTransactionViewModel
    ) {
        self.transactionViewModel = transactionViewModel
        self.makeTransactionViewModel = makeTransactionViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(finishIcon)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(dateLabel)
        scrollView.addArrangedSubview(detailStack)
        scrollView.addArrangedSubview(actionsContainer)
        
        scrollView.addArrangedSubview(backButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        finishIcon.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        actionsContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
        
        detailStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        
        scrollView.container.setCustomSpacing(4, after: finishIcon)
        
        scrollView.container.setCustomSpacing(4, after: titleLabel)
        
        scrollView.container.setCustomSpacing(46, after: actionsContainer)
     
        createStackItems()
        
    }
    
    public override func initialRequest() {
        transactionViewModel.loadTransaction(id: transaction?.id)
    }

    public override func setupObservers() {
        backButton.clicked { [weak self] in
            guard let self = self else { return }
            self.popToRoot(mainTabIndex: PayTab.home)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        actionsContainer.saveButton.clicked { [weak self] in
            guard let self = self else { return }
            self.checkSaveTransaction()
        }
        
        actionsContainer.detailButton.clicked { [weak self] in
            guard let self = self else { return }
            self.createPdf()
        }
        
        actionsContainer.retryButton.clicked { [weak self] in
            guard let self = self else { return }
            self.showRetryTransaction {
                self.retryTransaction()
            }
        }
        
        handle(transactionViewModel.$transaction,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.fullTransaction = data?.transaction
            self.createStackItems()
        })
        
        handle(makeTransactionViewModel.$retryTransaction,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            self.showSuccess(text: data?.transactions?.fields?.first?.value)
        })
        
    }
    
    public func getTransaction(completion: @escaping ((TransactionModel?) -> Void) ) {
        if let fullTransaction = fullTransaction {
            completion(fullTransaction)
        } else {
            transactionViewModel.loadTransaction(id: self.transaction?.id) { [weak self] in
                guard let self = self else { return }
                completion(self.fullTransaction)
            }
        }
    }

    
}
