//
//  MainCardsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//
import CenteredCollectionView
import UIKit
import OlchaUI
class MainCardsViewController: BaseViewController<TitleNavigationBar> {

    private let collectionHeight: CGFloat = 170
    
    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.backgroundColor = .clear
        scrollView.settings.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var collectionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    let layout = CenteredCollectionViewFlowLayout()
    public lazy var collection: UICollectionView = {
        layout.itemSize = .init(width: UIScreen.main.bounds.width * 0.8,
                                height: collectionHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        
        let collection = UICollectionView(centeredCollectionViewFlowLayout: layout)

        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(forCell: MainCardItem.self)
        collection.registerClass(forCell: AddCardItem.self)
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    lazy var paginator: UIPageControl = {
        let paginator = UIPageControl()
        paginator.pageIndicatorTintColor = .olchaAccentColor
        paginator.currentPageIndicatorTintColor = .olchaAccentColor
        paginator.pageIndicatorTintColor = .olchaGray
        return paginator
    }()
    
    public let settings = CardSettingsView()
    
    private lazy var historyTransactions: TransactionsListView = {
        let view = TransactionsListView()
        view.observers = paymentObservers
        return view
    }()
    
    public lazy var deleteCardButton: IButton = {
        let button = IButton()
        button.setTitle("delete_card".localized(), for: .normal)
        button.round(8)
        button.backgroundColor = .olchaAccentColor.withAlphaComponent(0.1)
        button.setTitleColor(.olchaAccentColor, for: .normal)
        button.titleLabel?.style(.medium, 14)
        return button
    }()
    
    public let observers = CardSettingsObserver()
    
    public let paymentObservers = PushPaymentHelper()
    
    var cards: [UserBankCardModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    var currentIndex: Int? = nil {
        didSet {
            cardChanged()
        }
    }
    
    var canShow: Bool {
        currentIndex == nil
    }
    
    //MARK: Closures
    public var addCardObserver: (() -> Void)?
    
    weak var coordinator: MainCardsCoordinatorProtocol?
    
    let bankCardsViewModel: BankCardsViewModel
    let crudCardViewModel: CrudCardViewModel
    
    public init(bankCardsViewModel: BankCardsViewModel,
                crudCardViewModel: CrudCardViewModel) {
        self.bankCardsViewModel = bankCardsViewModel
        self.crudCardViewModel = crudCardViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(collectionContainer)
        collectionContainer.addSubview(collection)
        collectionContainer.addSubview(paginator)
        scrollView.addArrangedSubview(settings)
        scrollView.addArrangedSubview(historyTransactions)
        scrollView.addArrangedSubview(deleteCardButton)
        
        scrollView.addArrangedSubview(refreshControl)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        collectionContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        collection.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(collectionHeight)
        }
        
        paginator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collection.snp.bottom).inset(-16)
            make.height.equalTo(10)
            make.bottom.equalToSuperview().inset(32)
        }
        
        settings.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        historyTransactions.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        deleteCardButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
    }
    
    public override func configureViews() {
        
        
        navigationBar.backButton.isHidden = true
        container.backgroundColor = .lightGrayBackground
        
        scrollView.container.setCustomSpacing(32, after: collection)
        scrollView.container.setCustomSpacing(24, after: settings)
        scrollView.container.setCustomSpacing(24, after: historyTransactions)
        
        languageUpdated()
        animateCollection()
    }
    
    override func languageUpdated() {
        historyTransactions.setupHeader(title: "transactions_history_card".localized())
        navigationBar.setTitle("cards".localized())
        deleteCardButton.setTitle("delete_card".localized(), for: .normal)
        collection.reloadData()
        historyTransactions.languageUpdated()
    }
    
    public func cardChanged() {
        
        settings.isHidden = canShow
        historyTransactions.isHidden = canShow
        deleteCardButton.isHidden = canShow
        
        guard let currentIndex = currentIndex else { return }

        if cards.isGreater(currentIndex) {
            settings.setup(with: cards[currentIndex])
            historyTransactions.setup(data: cards[currentIndex].transactions ?? [])
        }
    }

    override func setupObservers() {
        
        settings.cardMakeDefault.button.clicked { [weak self] in
            guard let self = self,
                  let index = self.currentIndex,
                  self.cards.isGreater(index)
            else { return }
            
            let oldValue = self.cards[index].isDefault
            
            self.cards.forEach { $0.isDefault = false }
            self.cards[index].isDefault = !oldValue
            
            self.cardChanged()
            self.updateCard(userBankCardModel: self.cards[index])
        }
        
        
        observers.cardUpdated.sink { [weak self] card in
            guard let self = self,
                  let card = card,
                  let index = self.cards.firstIndex(where: { $0.id == card.id })
            else { return }
            self.cards[index] = card
            self.cardChanged()
            self.collection.reloadData()
            self.updateCard(userBankCardModel: card)
            
        }.store(in: &bag)
        
        handle(bankCardsViewModel.$bankCards,
               success: { [weak self] data in
            guard let self = self else { return }
            self.cards = data?.bank_cards ?? []
            self.currentIndex = self.cards.isEmpty ? nil : 0
            self.animateCollection()
        })
        
        handle(crudCardViewModel.$removeCardData) { [weak self] data in
            guard let self = self else { return }
            self.bankCardsViewModel.initialLoad()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.bankCardsViewModel.initialLoad()
        }
        
        pushObservers()
    }
    
    override func initialRequest() {
        bankCardsViewModel.initialLoad()
    }
    
    override func refreshList(_ sender: AnyObject) {
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    private func removeCard(at index: Int) {
        guard cards.isGreater(index) else { return }
        crudCardViewModel.removeCard(card: cards[index])
        cards.remove(at: index)
        
        calculateCurrentIndex(index: index)
    }
    
    private func calculateCurrentIndex(index: Int) {
        
        let currentIndex = min(max(0, (index - 1)), self.cards.count)
        
        self.currentIndex = currentIndex
        
        if self.cards.isEmpty {
            self.currentIndex = nil
        }
        
        animateCollection()
    }
    
    private func animateCollection() {
        guard let currentIndex = currentIndex else {
            collection.reloadData()
            collection.scrollToItem(at: .init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
//            layout.invalidateLayout()
            
            return
        }

        collection.scrollToItem(at: .init(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        collection.reloadData()
    }
    
    private func updateCard(userBankCardModel: UserBankCardModel) {
        crudCardViewModel.updateCard(card: userBankCardModel)
    }
    
    private func pushObservers() {
        settings.cardColor.button.clicked { [weak self] in
            guard let self = self,
                  let index = self.currentIndex else { return }
            self.coordinator?.presentCardColor(observers: self.observers,
                                               card: self.cards[index])
        }
        
        settings.cardName.button.clicked { [weak self] in
            guard let self = self,
                  let index = self.currentIndex else { return }
            self.coordinator?.presentCardName(observers: self.observers,
                                              card: self.cards[index])
        }
        
        addCardObserver = { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushAddNewCard {
                self.initialRequest()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        deleteCardButton.clicked { [weak self] in
            guard let self = self,
                  let index = self.currentIndex else { return }
            self.showDeleteCard {
                self.removeCard(at: index)
            }
        }
        
        paymentObservers
            .pushPaymentDetail
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushPaymentDetail(transaction: data)
            }.store(in: &bag)
        
        paymentObservers
            .pushPaymentMonitoring
            .sink { [weak self] canPush in
                guard let self = self, canPush else { return }
                self.coordinator?.pushMonitoring()
            }.store(in: &bag)
        
        
        historyTransactions.showAllTransactions { [weak self] in
            guard let self = self,
                  let index = self.currentIndex,
                  self.cards.isGreater(index) else { return }
            
            self.coordinator?.pushCardMonitoring(bankCard: self.cards[index])
        }
    }
}


