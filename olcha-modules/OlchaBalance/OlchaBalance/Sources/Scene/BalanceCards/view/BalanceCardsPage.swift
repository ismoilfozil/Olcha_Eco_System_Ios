//
//  BalansCardsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 07/11/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaBankCards
import OlchaUtils

public class BalanceCardsPage: BaseViewController<BackNavigationBar> {
    
    private let scrollView = UIScrollView()
    private let scrollContainer = UIStackView()
    private let cardFill = CardFillView()
    let cardsTable = BaseTableView()
    private let addButton = OlchaButton()
    
    let bottomActionsContainer = UIStackView()
    let hintTitle = UILabel()
    let nextButton = OlchaButton()
    
    var cards: [BankCard] = [] {
        didSet {
            if cards.isEmpty {
                cardFill.isHidden = false
                cardsTable.isHidden = true
                addButton.isHidden = true
            } else {
                cardFill.discard()
                cardFill.isHidden = true
                cardsTable.isHidden = false
                addButton.isHidden = false
            }
            cardsTable.reloadData()
        }
    }
    
    private let viewModel: BankCardViewModel
    
    let observers = CardFillObservers()
    
    let loadCards = PassthroughSubject<Bool, Never>()
    
    weak var coordinator: BalanceCoordinatorProtocol?
    
    var selectedCard: BankCard? {
        didSet {
            hintTitle.isHidden = (selectedCard != nil)
            (selectedCard == nil) ? nextButton.disableButton() : nextButton.enableButton()
        }
    }
    
    public var creditVerificationObserver: (() -> Void)?
    
    public init(viewModel: BankCardViewModel = BankCardsDIContainer.shared.resolve()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        
        container.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        scrollContainer.addArrangedSubview(cardFill)
        scrollContainer.addArrangedSubview(cardsTable)
        scrollContainer.addArrangedSubview(addButton)
   
        container.addSubview(bottomActionsContainer)
        
        bottomActionsContainer.addArrangedSubview(hintTitle)
        bottomActionsContainer.addArrangedSubview(nextButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        cardFill.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        cardsTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bottomActionsContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    public override func configureViews() {
        navigationBar.setTitle("from_bank_card".localized())
        
        addButton.setTitle("add_card".localized())
        addButton.settings.backgroundColor = .olchaGreen
        
        scrollContainer.layoutIfNeeded()
        scrollContainer.axis = .vertical
        scrollContainer.spacing = 16
        
        cardsTable.delegate = self
        cardsTable.dataSource = self
        cardsTable.configure()
        cardsTable.registerClass(forCell: BankCardRoom.self)
        cardsTable.registerClass(forCell: CardFillRoom.self)
        cardsTable.isScrollEnabled = false
        
        scrollView.delegate = self
        
        cardFill.observers = observers
        
        cardFill.isHidden = true
        cardsTable.isHidden = true
        addButton.isHidden = true
        
        bottomActionsContainer.backgroundColor = .olchaWhite
        bottomActionsContainer.spacing = 8
        bottomActionsContainer.axis = .vertical
        
        hintTitle.style(.medium, 14)
        hintTitle.textColor = .olchaAccentColor
        hintTitle.text = "select_card".localized()
        hintTitle.textAlignment = .center
        
        nextButton.setTitle("continue".localized())
        selectedCard = nil
    }
    
    public override func initialRequest() {
        loadCards.send(true)
    }
#warning("reflection removed")
    public override func setupObservers() {
        
        loadCards.sink { [weak self] canLoad in
            guard let self = self else { return }
            self.viewModel.loadBankCards(
                filter: .init(
//                    settings: .init(reflection: .balance)
                )
            )
        }.store(in: &bag)
        
        handle(viewModel.$cardUploaded, showLoader: true) { [weak self] data in
            guard let self = self, data != nil else { return }
            self.loadCards.send(true)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }

        handle(viewModel.$bankCard) { [weak self] data in
            guard let self = self,
                  let card = data else { return }
            self.observers.requestFinished.send(true)
            self.cards = [card]
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.observers.requestFinished.send(true)
        }
        
        viewModel
            .$codeSent
            .sink { [weak self] isSent in
                guard let self = self, isSent else { return }
                self.observers.requestFinished.send(true)
                self.observers.codeSentObserver.send(true)
            }.store(in: &bag)
        
        observers.sendCodeObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.verifyBankCardPhone(model: model)
            }.store(in: &bag)
        
        observers.sendCardObserver
            .sink { [weak self] model in
                guard let self = self else { return }
                self.viewModel.uploadBankCard(model: model)
            }.store(in: &bag)
        
        handle(viewModel.$cards, showLoader: true, success: { [weak self] data in
            guard let self = self else { return }
            self.cards = data ?? []
        })
    
        addButton.settings.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentAddCardPage(loadCards: self.loadCards)
        }
        
        nextButton.settings.clicked { [weak self] in
            guard let self = self, let card = self.selectedCard else { return }
            self.coordinator?.pushEnterPayment(card: card)
        }
        
        viewModel.creditVerificationObserver = creditVerificationObserver
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = cardsTable.calculateTableViewHeight()

        cardsTable.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
 
    func makeDefault(card: BankCard?) {
        viewModel.makeDefault(id: card?.id)
    }
    
    func delete(card: BankCard?, completion: (() -> Void)?) {
        viewModel.remove(id: card?.id, completion: completion)
    }
    
    func sendCode(model: VerificationUploadCode) {
        viewModel.verifyBankCardPhone(model: model)
    }

}

