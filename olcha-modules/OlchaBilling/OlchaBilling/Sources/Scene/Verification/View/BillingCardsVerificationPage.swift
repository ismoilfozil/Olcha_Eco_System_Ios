//
//  BillingCardsVerificationPage.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 17/08/23.
//

import UIKit
import Combine
import OlchaUI
import OlchaUtils
import OlchaBankCards
import OlchaVerification

public protocol AddBillingCardCoordinatorProtocol {
    func presentAddBillingCard(filter: BillingPaymentFilter,
                               loadCards: PassthroughSubject<Bool, Never>,
                               creditVerificationObserver: (() -> Void)?)
}

public class BillingCardsVerificationPage: BaseViewController<TitleNavigationBar>, BankCardsVerificationPageProtocol {
    
    public var withStatus: Bool = true {
        didSet {
            status.isHidden = !withStatus
        }
    }
    
    public var coordinator: OlchaVerification.VerificationCoordinatorProtocol?
    public var addBillingCardCoordinator: AddBillingCardCoordinatorProtocol?
    
    public var completion: (() -> Void)?
    
    private let status: PercentageVerificationStatus = {
        let view = PercentageVerificationStatus()
        view.setup(statusStep: .bankCard)
        return view
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: BillingVerificationCardRoom.self)
        table.registerClass(forCell: AddBillingCardRoom.self)
        table.registerClass(forCell: BillingPaymentHeaderRoom.self)
        table.configure()
        table.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        return table
    }()
    
    private let confirmButton: OlchaButton = {
        let button = OlchaButton()
        button.disableButton()
        return button
    }()
    
    var input: Input
    var output: Output
    let viewModel: BillingViewModel
    let bankCardViewModel: BankCardViewModel
    let verificationViewModel: VerificationViewModel
    
    var openedMenuID: Int?
    
    public init(viewModel: BillingViewModel,
                bankCardViewModel: BankCardViewModel,
                verificationViewModel: VerificationViewModel,
                input: Input = .init(),
                output: Output = .init()) {
        self.input = input
        self.output = output
        self.viewModel = viewModel
        self.bankCardViewModel = bankCardViewModel
        self.verificationViewModel = verificationViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        
        container.addSubview(status)
        container.addSubview(table)
        table.addSubview(refreshControl)
        container.addSubview(confirmButton)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            if withStatus {
                make.top.equalTo(status.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.bottom.equalToSuperview()
        }
        
        status.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
    }
    
    public override func configureViews() {
        languageUpdated()
    }
    
    public override func languageUpdated() {
        confirmButton.setTitle("confirm".localized())
        navigationBar.setTitle("verify_profile".localized(.verification))
    }
    
    public override func setupObservers() {
        handle(viewModel.$bankCards,
               success: { [weak self] data in
            guard let self = self else { return }
            input.parentCards = data?.collection ?? []
            setSelectedCard()
            checkButtonState()
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            input.cardsSkeleton.isAnimating = isLoading
            table.reloadData()
        })

        handle(verificationViewModel.$step,
               withError: false) { [weak self] data in
            guard let self = self, let data else { return }
            status.setProgress(data.percentage ?? 0)
        }
        
        handle(bankCardViewModel.$removeCard,
               withError: true,
               loading: { [weak self] isLoading in
            guard let self else { return }
            isLoading ? showPostProgress() : hidePostProgress()
        })
//        status.stepObserver = { [weak self] step in
//            guard let self = self else { return }
//            self.coordinator?.pushVerification(step: step)
//        }
        
        output.loadCards.sink { [weak self] canLoad in
            guard let self = self else { return }
            output.reset()
            loadBankCards()
        }.store(in: &bag)
        
        bankCardViewModel.creditVerificationObserver = { [weak self] in
            guard let self = self else { return }
            verifyCreditObserver()
        }
        
        confirmButton.clicked { [weak self] in
            guard let self else { return }
            completion?()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        guard let openedMenuID else { return }
        self.openedMenuID = nil
        table.reloadData()
    }
    
    public override func initialRequest() {
        verifyCreditObserver()
        loadBankCards()
    }
    
    private func loadBankCards() {
        viewModel.loadBankCards(
            filter: .init()
                .set(reflection: ReflectionType.nasiya_all_bank_cards)
        )
    }
    
    public func checkButtonState() {
        let isCardsEmpty = input.parentCards
            .map({ $0.bankCards.isEmpty })
            .allSatisfy({ $0 == true })
        isCardsEmpty ? confirmButton.disableButton() : confirmButton.enableButton()
    }
    
    public override func refreshList(_ sender: AnyObject) {
        openedMenuID = nil
        output.reset()
        input.parentCards.removeAll()
        table.reloadData()
        checkButtonState()
        refreshControl.endRefreshing()
        loadBankCards()
    }
    
    public func setSelectedCard(cardId: Int? = nil) {
        for (s, collection) in input.parentCards.enumerated() {
            if let cardId = cardId {
                // Setting card based on ID
                guard let r = collection.bankCards.firstIndex(where: { $0.getId() == cardId }) else {
                    continue
                }
                output.selectedCardAlias = collection.alias
                output.selectedCardId = cardId
                output.selectedCard = IndexPath(row: r + 1, section: s)
            } else {
                // Setting card based on isDefault
                guard let defaultCard = collection.bankCards.first(where: { $0.getIsDefault() }) else {
                    continue
                }
                output.selectedCardAlias = collection.alias
                output.selectedCardId = defaultCard.getId()
                output.selectedCard = IndexPath(row: 1, section: s)
            }
        }
        table.reloadData()
    }
    
}
