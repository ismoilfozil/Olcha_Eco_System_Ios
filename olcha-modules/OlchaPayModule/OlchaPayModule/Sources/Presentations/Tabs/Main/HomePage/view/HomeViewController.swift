//
//  HomeViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 01/02/23.
//

import UIKit
import OlchaUI
import OlchaAuth

public class HomeViewController: BaseViewController<OlchaPayNavigationBar> {

    private lazy var gradientBackground: GradientView = {
        let view = GradientView()
        view.setupGradientView(.hex("#AE438F"), .olchaAccentColor)
        return view
    }()
    
    lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()

        scrollView.settings.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.settings.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        scrollView.settings.scrollIndicatorInsets = .zero
        scrollView.settings.contentInsetAdjustmentBehavior = .never
        scrollView.settings.alwaysBounceVertical = true
        return scrollView
    }()
    
    //MARK: - sections
    private let searchView = HomeSearchView()
    public let homeBalanceView = HomeBalanceView()
    public let homeMenuView = HomeMenuView()
    public let homePhoneView = HomePhoneView()
    
    public let categoriesGroup = CategoriesGroupView()
    public let savedTransactionsGroup = SavedTransactionsGroupView()
    
    public let newsGroup = HomeNewsView()
    public let historyTransactionsGroup = TransactionsListView()
    
    
    lazy var gradientViews: [UIView] = [
        navigationBar,
        searchView,
        homeBalanceView,
        homeMenuView
    ]
    
    public let sections: [Section] = [
        .phone,
        .categories,
        .saved,
        .news,
        .history
    ]
    
    private let contactManager = ContactManager()
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    let observerHelper = PushPaymentHelper()
    
    let bankCardsViewModel: BankCardsViewModel
    
    let newsViewModel: NewsViewModel
    
    let paymentsViewModel: PaymentsViewModel
    let crudCardViewModel: CrudCardViewModel
    let transactionViewModel: TransactionViewModel
    let savedTransactionsViewModel: SavedTransactionsViewModel
    
    var bankCardsData: BankCardsData?
    
    var news: [NewsModel] = [] {
        didSet {
            newsGroup.setup(data: news)
        }
    }
    
    var categories: [CategoryModel] = [] {
        didSet {
            categoriesGroup.setup(data: categories)
        }
    }
    
    var historyTransactions: [TransactionModel] = [] {
        didSet {
            historyTransactionsGroup.setup(data: historyTransactions)
        }
    }
    
    var savedTransactions: [SavedTransactionModel] = [] {
        didSet {
            savedTransactionsGroup.setup(data: savedTransactions)
        }
    }
    
    var isFirstLaunch: Bool = true
    
    public init(bankCardsViewModel: BankCardsViewModel,
                crudCardViewModel: CrudCardViewModel,
                paymentsViewModel: PaymentsViewModel,
                transactionViewModel: TransactionViewModel,
                savedTransactionsViewModel: SavedTransactionsViewModel,
                newsViewModel: NewsViewModel) {
        self.bankCardsViewModel = bankCardsViewModel
        self.crudCardViewModel = crudCardViewModel
        self.paymentsViewModel = paymentsViewModel
        self.transactionViewModel = transactionViewModel
        self.newsViewModel = newsViewModel
        self.savedTransactionsViewModel = savedTransactionsViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setupViews() {
        navigationBar.removeFromSuperview()
        container.addSubview(scrollView)
        scrollView.settings.addSubview(gradientBackground)
        gradientBackground.addSubview(navigationBar)
        gradientBackground.addSubview(searchView)
        gradientBackground.addSubview(homeBalanceView)
        gradientBackground.addSubview(homeMenuView)

        setupStackSections()

        scrollView.settings.addSubview(refreshControl)

    }
    
    open override func autolayout() {
        
        navigationBar.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(UIApplication.shared.topInset)
            make.height.equalTo(navigationHeight)
        }
        
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        gradientBackground.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(scrollView.container.snp.top).inset(-16)
        }
        
        scrollView.container.snp.remakeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.left.right.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).inset(-8)
        }
        
        homeBalanceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).inset(-40)
        }
        
        homeMenuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(homeBalanceView.snp.bottom).inset(-40)
            make.bottom.equalToSuperview().inset(24)
        }
        
    }
    
    open override func configureViews() {
        navigationBar.backgroundColor = .clear
        container.backgroundColor = .olchaLightNeutralGray
    
        historyTransactionsGroup.isHidden = true
        historyTransactionsGroup.observers = observerHelper

        newsGroup.setupHeader()
        historyTransactionsGroup.setupHeader(title: "transactions_history_card".localized())
        categoriesGroup.setupHeader(title: "categories".localized())
        savedTransactionsGroup.setupHeader(title: "saved_transactions".localized())
        
        homePhoneView.phoneField.setPhone(value: AuthGlobalDefaults.user.phone)
    }
    
    public override func languageUpdated() {
        [homeBalanceView,
         homeMenuView,
         homePhoneView,
         categoriesGroup,
         savedTransactionsGroup,
         newsGroup,
         historyTransactionsGroup].forEach {
            $0.languageUpdated()
        }
        navigationBar.languageUpdated()
        searchView.setupPlaceholder()
        newsGroup.setupHeader()
        historyTransactionsGroup.setupHeader(title: "transactions_history_card".localized())
        categoriesGroup.setupHeader(title: "categories".localized())
        savedTransactionsGroup.setupHeader(title: "saved_transactions".localized())
     
        guard !isFirstLaunch else { return }
        resetDatas()
        initialResourcesRequest()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paymentsViewModel.loadPhoneCodes()
    }
    
    public override func setupObservers() {
        homeBalanceView.dropDownButton.clicked { [weak self] in
            guard let self = self else { return }
            
            self.coordinator?.presentMyCardsList(addCardObserver: {
                self.bankCardsViewModel.initialLoad()
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        pushObservers()
        handleObservers()
    }
    
    private func pushObservers() {
        homePhoneView.phoneField.payButton.clicked { [weak self] in
            guard let self else { return }
            if self.homePhoneView.phoneField.isValidated(withMessage: true) {
                self.coordinator?.pushPhoneMakeTransaction(phone: self.homePhoneView.phoneField.getValue())
            }
        }
        
        homePhoneView.phoneField.contactButton.clicked { [weak self] in
            guard let self else { return }
            contactManager.getContact(self) { phone in
                self.homePhoneView.phoneField.setPhone(value: phone)
            }
        }
        
        categoriesGroup.header.seeAllClicked { [weak self] in
            guard let self, paymentsViewModel.categories != .loading else { return }
            Funcs.changeTab(PayTab.categories)
        }
        
        categoriesGroup.clickObserver { [weak self] data in
            guard let self = self else { return }
            self.coordinator?.pushProviders(category: data)
        }
        
        newsGroup.header.seeAllClicked { [weak self] in
            guard let self, newsViewModel.newsData != .loading else { return }
            self.coordinator?.pushNewsList()
        }
        
        newsGroup.newsClicked { [weak self] index in
            guard let self = self else { return }
            self.coordinator?.pushDetailedNews(news: self.news,
                                               currentIndex: index,
                                               currentPage: 1)
        }
        
        savedTransactionsGroup.clickObserver { [weak self] model in
            guard let self, savedTransactionsViewModel.initialSavedTransactions != .loading else { return }
            self.coordinator?.pushMakeTransaction(savedTransaction: model)
        }
        
        savedTransactionsGroup.header.seeAllClicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushSavedTransactionsList()
        }
        
        navigationBar.notificationButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushNotificationsList()
        }
        
        navigationBar.langButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushLanguageSettings()
        }
        
        homeMenuView.clickedObserver { [weak self] section in
            guard let self = self else { return }
            switch section {
            case .qr:
                self.coordinator?.pushQR()
                break
            case .my_cards:
                Funcs.changeTab(PayTab.cards)
                break
            default:
                break
            }
        }
        
        observerHelper
            .pushPayment
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
                self.coordinator?.pushPaymentPage(service: nil)
            }.store(in: &bag)
        
        observerHelper
            .pushPaymentDetail
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushPaymentDetail(transaction: data)
            }.store(in: &bag)
        
        observerHelper
            .pushPaymentMonitoring
            .sink { [weak self] canPush in
                guard let self = self, canPush else { return }
                self.coordinator?.pushMonitoring()
            }.store(in: &bag)
        
        historyTransactionsGroup.showAllTransactions { [weak self] in
            guard let self = self else { return }
            Funcs.changeTab(PayTab.monitoring)
        }
        
        searchView.button.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.pushSearch(categoryID: nil)
        }
    }
    
    private func handleObservers() {
        handle(bankCardsViewModel.$bankCards,
               success: { [weak self] data in
            guard let self = self else { return }
            self.bankCardsData = data
        })
      
        handle(bankCardsViewModel.$balances,
               success: { [weak self] data in
            guard let self = self else { return }
            self.homeBalanceView.setup(totalAmount: data?.total_sum)
        })
                
        handle(newsViewModel.$newsData,
               success: { [weak self] data in
            guard let self = self else { return }
            self.news = data?.news ?? []
        }, failure: { [weak self] error in
            guard let self else { return }
            news = []
        }, loading: { [weak self] isLoading in
            guard let self else { return }
            newsGroup.skeleton.isAnimating = isLoading
            newsGroup.reloadData()
        })

        handle(paymentsViewModel.$categories,
               success: { [weak self] data in
            guard let self = self else { return }
            self.categories = data?.getCategories() ?? []
        }, failure: { [weak self] error in
            guard let self else { return }
            categories = []
        },loading: { [weak self] isLoading in
            guard let self else { return }
            categoriesGroup.skeleton.isAnimating = isLoading
            categoriesGroup.reloadData()
        })
        
        handle(transactionViewModel.$initialTransactions) { [weak self] data in
            guard let self = self else { return }
            self.historyTransactions = data?.transactions ?? []
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.historyTransactions = []
        }
        
        handle(savedTransactionsViewModel.$initialSavedTransactions) { [weak self] data in
            guard let self = self else { return }
            savedTransactions = data?.saved_transactions ?? []
        } failure: { [weak self] error in
            guard let self = self else { return }
            savedTransactions = []
        } loading: { [weak self] isLoading in
            guard let self else { return }
            savedTransactionsGroup.skeleton.isAnimating = isLoading
            savedTransactionsGroup.reloadData()
        }
        
        handle(savedTransactionsViewModel.$deleteTransaction,
               success: { [weak self] data in
            guard let self = self else { return }
            self.savedTransactionsViewModel.loadInitialSavedTransactions()
        })
        
        
        handle(savedTransactionsViewModel.$saveTransaction,
               success: { [weak self] data in
            guard let self = self else { return }
            self.savedTransactionsViewModel.loadInitialSavedTransactions()
        })

        handle(crudCardViewModel.$changedCardsList,
               withError: false,
               success: { [weak self] _ in
            guard let self else { return }
            transactionViewModel.loadInitialTransactions()
        })
    }
    
    public override func initialRequest() {
        
        bankCardsViewModel.initialLoad()
        initialResourcesRequest()
        
    }
    
    public override func refreshList(_ sender: AnyObject) {
        resetDatas()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    private func initialResourcesRequest() {
        newsViewModel.loadImages(page: 1)
        paymentsViewModel.loadCategories()
        transactionViewModel.loadInitialTransactions()
        savedTransactionsViewModel.loadInitialSavedTransactions()
    }
    
    private func resetDatas() {
        categoriesGroup.resetData()
        newsGroup.resetData()
        savedTransactionsGroup.resetData()
        historyTransactionsGroup.resetData()
    }
}
