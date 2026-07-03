//
//  VerificationPage3.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 15/09/22.
//

import UIKit
import Combine
import OlchaBankCards
import OlchaUI

public protocol BankCardsVerificationPageProtocol: UIViewController, AnyObject {
    var withStatus: Bool { get set }
    var coordinator: VerificationCoordinatorProtocol? { get set }
    var completion: (() -> Void)? { get set }
}
public class BankCardsVerificationPage: BaseViewController<TitleNavigationBar>, BankCardsVerificationPageProtocol {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    private let scrollContainer = UIStackView()
    private let status: PercentageVerificationStatus = {
        let view = PercentageVerificationStatus()
        view.setup(statusStep: .bankCard)
        return view
    }()
    private let titleLabel = UILabel()
    private let cardFill = CardFillView()
    let cardsTable = BaseTableView()
    private let confirmButton = OlchaButton()
    private let returnProfileButton = IButton()
    
    public weak var coordinator: VerificationCoordinatorProtocol?
    
    let sections: [Section] = [.card, .add]
    
    var cards: [BankCard] = [] {
        didSet {
            
            if cards.isEmpty {
                cardFill.isHidden = false
                cardsTable.isHidden = true
            } else {
                cardFill.discard()
                cardFill.isHidden = true
                cardsTable.isHidden = false
            }
            cardsTable.reloadData()
            checkButtonState()
        }
    }
    
    private let bankCardViewModel: BankCardViewModel
    private let verificationViewModel: VerificationViewModel
    
    public var completion: (() -> Void)?
    
    
    var openedMenuID: Int?
    
    let observers = CardFillObservers()
    let loadCards = PassthroughSubject<Bool, Never>()
    
    public var withStatus: Bool = true {
        didSet {
            status.isHidden = !withStatus
            returnProfileButton.isHidden = !withStatus
        }
    }
    
    public init(bankCardViewModel: BankCardViewModel,
                verificationViewModel: VerificationViewModel) {
        self.bankCardViewModel = bankCardViewModel
        self.verificationViewModel = verificationViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func setupViews() {
        
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addArrangedSubview(status)
        scrollContainer.addArrangedSubview(titleLabel)
        scrollContainer.addArrangedSubview(cardFill)
        scrollContainer.addArrangedSubview(cardsTable)
        scrollContainer.addArrangedSubview(confirmButton)
        scrollContainer.addArrangedSubview(returnProfileButton)
   
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        returnProfileButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("verify_profile".localized(.verification))
        
        confirmButton.setTitle("confirm".localized())
        returnProfileButton.setTitle("go_profile".localized(), for: .normal)
        returnProfileButton.setTitleColor(.olchaTextBlack, for: .normal)
        returnProfileButton.titleLabel?.style(.medium, 16)
        returnProfileButton.backgroundColor = .lightGray1
        returnProfileButton.layer.cornerRadius = 8
        returnProfileButton.layer.borderWidth = 0
        
        scrollContainer.layoutIfNeeded()
        scrollContainer.axis = .vertical
        titleLabel.style(.semibold, 24)
        titleLabel.text = "bank_cards".localized()
        titleLabel.numberOfLines = 0
        scrollContainer.spacing = 16
        scrollContainer.setCustomSpacing(24.0, after: status)
        scrollContainer.setCustomSpacing(16.0, after: titleLabel)
        
        cardsTable.delegate = self
        cardsTable.dataSource = self
        cardsTable.configure()
        cardsTable.registerClass(forCell: BankCardRoom.self)
        cardsTable.registerClass(forCell: CardFillRoom.self)
        cardsTable.registerClass(forCell: AddBillingCardRoom.self)
        cardsTable.isScrollEnabled = false
        
        scrollView.delegate = self
        cardFill.observers = observers
        
        
        cardFill.isHidden = true
        cardsTable.isHidden = true
        returnProfileButton.isHidden = !withStatus
        checkButtonState()
    }
    
    public override func initialRequest() {
        loadCards.send(true)
        verificationViewModel.loadStep()
    }
    
    public override func setupObservers() {
        
        loadCards.sink { [weak self] canLoad in
            guard let self = self else { return }
            self.bankCardViewModel.loadBankCards()
        }.store(in: &bag)
        
        
        handle(bankCardViewModel.$cardUploaded, showLoader: true) { [weak self] data in
            guard let self = self, data != nil else { return }
            self.loadCards.send(true)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
        
        handle(bankCardViewModel.$bankCard) { [weak self] data in
            guard let self = self,
                  let card = data else { return }
            self.observers.requestFinished.send(true)
            self.cards = [card]
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
        
        bankCardViewModel
            .$codeSent
            .sink { [weak self] isSent in
                guard let self = self, isSent else { return }
                self.observers.requestFinished.send(true)
                self.observers.codeSentObserver.send(true)
            }.store(in: &bag)
        
        observers.sendCodeObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.bankCardViewModel.verifyBankCardPhone(model: model)
            }.store(in: &bag)
        
        observers.sendCardObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.bankCardViewModel.uploadBankCard(model: model)
            }.store(in: &bag)
        
        handle(bankCardViewModel.$cards,
               showLoader: true, success: { [weak self] data in
            guard let self = self else { return }
            self.cards = data ?? []
        })
        
        handle(bankCardViewModel.$removeCard,
               withError: true,
               loading: { [weak self] isLoading in
            guard let self else { return }
            isLoading ? showPostProgress() : hidePostProgress()
        })
        
        confirmButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            completion?()
        }
        
        returnProfileButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.navigationController.popToRootViewController(animated: true)
        }
        
        handle(verificationViewModel.$step, withError: false) { [weak self] data in
            guard let self = self, let data else { return }
            status.setProgress(data.percentage ?? 0)
        }

//        status.stepObserver = { [weak self] step in
//            guard let self = self else { return }
//            self.coordinator?.pushVerification(step: step)
//        }
        
        bankCardViewModel.creditVerificationObserver = { [weak self] in
            guard let self = self else { return }
            OlchaVerificationDIContainer.shared.authCreditViewModel().verifyCredit()
            verificationViewModel.loadStep()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        self.openedMenuID = nil
        self.cardsTable.reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = cardsTable.calculateTableViewHeight()
        
        cardsTable.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    private func checkButtonState() {
        confirmButton.isHidden = cards.isEmpty
    }
 
    
    func makeDefault(card: BankCard?) {
        bankCardViewModel.makeDefault(id: card?.id)
    }
    
    func delete(card: BankCard?, completion: (() -> Void)?) {
        bankCardViewModel.remove(id: card?.id, completion: completion)
    }
    
    func sendCode(model: VerificationUploadCode) {
        bankCardViewModel.verifyBankCardPhone(model: model)
    }
}
