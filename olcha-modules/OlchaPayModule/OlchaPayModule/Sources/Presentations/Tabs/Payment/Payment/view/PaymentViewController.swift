//
//  PaymentViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 20/02/23.
//

import UIKit
import OlchaUI
import IQKeyboardManagerSwift
import Combine
import OlchaUtils
public class PaymentViewController: BaseViewController<BackNavigationBar> {
    
    lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        scrollView.settings.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var cardSelectView: CardSelectView = {
        let view = CardSelectView()
        return view
    }()
    
    lazy var acceptButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("pay".localized())
        button.disableButton()
        return button
    }()
    
    let mainFieldKeys: [ ServiceFieldType ] = [
        .money,
        .purchased,
        .preamount
    ]
    
    public var isFieldsGenerated: Bool = false
    public var fields: [ PaymentFieldProtocol ] = []
    
    public var fieldTypes: [ PaymentType ] {
        getArrayList()
    }
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    let bankCardsViewModel: BankCardsViewModel
    
    let makeTransactionViewModel: MakeTransactionViewModel
    
    let paymentsViewModel: PaymentsViewModel
    
    var paymentHelper = MakePaymentHelper() {
        didSet {
            selectDefaultCardHelper.paymentHelper = paymentHelper
        }
    }
    
    let selectDefaultCardHelper: SelectDefaultCardHelper
    
    public override var validatedFields: [TField] {
        fields.map { $0.field }
    }
    
    public init(bankCardsViewModel: BankCardsViewModel,
                makeTransactionViewModel: MakeTransactionViewModel,
                paymentsViewModel: PaymentsViewModel) {
        self.bankCardsViewModel = bankCardsViewModel
        self.makeTransactionViewModel = makeTransactionViewModel
        self.paymentsViewModel = paymentsViewModel
        
        self.selectDefaultCardHelper = SelectDefaultCardHelper(
            bankCardsViewModel: self.bankCardsViewModel,
            paymentHelper: self.paymentHelper
        )
        
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        container.addSubview(acceptButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    public override func initialRequest() {
        loadInitialProvider()
        selectDefaultCardHelper.loadBankCards()
    }
    
    public override func setupObservers() {
        viewObservers()
        networkObservers()
        observerHelper()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        cardSelected()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
}
