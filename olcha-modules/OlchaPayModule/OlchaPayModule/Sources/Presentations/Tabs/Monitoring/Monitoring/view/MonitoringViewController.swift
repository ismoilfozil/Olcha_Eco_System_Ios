//
//  MonitoringViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 22/02/23.
//

import UIKit
import OlchaCore
import OlchaUI
import Combine
public class MonitoringViewController: BaseViewController<BackNavigationBar> {
    
    public enum InitialType {
        case tab
        case card
    }
    
    private lazy var actionsHeader: MonitoringActionsHeader = {
        let view = MonitoringActionsHeader()
        return view
    }()
    
    private lazy var totalHeader: MonitoringTotalHeader = {
        let view = MonitoringTotalHeader()
        return view
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        table.registerClass(forCell: TransactionRoom.self)
        table.backgroundColor = .olchaLightNeutralGray
        return table
    }()
    
    private lazy var emptyPlaceholder: EmptyPlaceholder = {
        let placeholder = EmptyPlaceholder()
        placeholder.setupImage(.empty_monitoring)
        placeholder.titleLabel.style(.semibold, 28)
        placeholder.isHidden = true
        return placeholder
    }()
    
    public weak var coordinator: MonitoringCoordinatorProtocol?
    
    public let observers = PushPaymentHelper()
    
    var transactions: [TransactionModel] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    var transactionsData: TransactionsData? {
        didSet {
            calculateTotal()
        }
    }
    
    public let viewModel: TransactionViewModel
    
    public let crudCardViewModel: CrudCardViewModel
    
    public var initialType: InitialType = .tab
    
    public var card: UserBankCardModel? {
        didSet {
            filters.cardID = card?.id
        }
    }
    
    public var features: TransactionsFeatures?
    
    public var filters = TransactionsFilters()
    
    public let acceptObserver = PassthroughSubject<TransactionsFilters, Never>()
    
    let skeleton = Skeleton(count: 20, isAnimating: true)
    
    public init(viewModel: TransactionViewModel,
                crudCardViewModel: CrudCardViewModel) {
        self.viewModel = viewModel
        self.crudCardViewModel = crudCardViewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(totalHeader)
        container.addSubview(actionsHeader)
        container.addSubview(table)
        container.addSubview(emptyPlaceholder)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        totalHeader.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        actionsHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(totalHeader.snp.bottom)
        }
        
        table.snp.makeConstraints { make in
            make.top.equalTo(actionsHeader.snp.bottom).inset(-2)
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyPlaceholder.snp.makeConstraints { make in
            make.edges.equalTo(table.snp.edges)
        }
    }
    
    public override func configureViews() {
        container.backgroundColor = .olchaLightNeutralGray
        
        navigationBar.setTitle("monitoring".localized())
        switch initialType {
        case .tab:
            navigationBar.navigationTitle.textAlignment = .center
            navigationBar.backButton.isHidden = true
            placeholder.mainButton.isHidden = true
            break
        case .card:
            navigationBar.navigationSubtitle.isHidden = false
            navigationBar.navigationSubtitle.text = card?.bank_card?.getSpacedPan()
            navigationBar.navigationTitle.textAlignment = .left
            placeholder.mainButton.isHidden = false
            break
        }

    }

    public override func setupObservers() {
        actionsHeader.filtrButton.clicked { [weak self] in
            guard let self = self else { return }
            self.coordinator?.presentMonitoringFilter(
                acceptObserver: self.acceptObserver,
                bankCard: self.card,
                features: self.features,
                filters: self.filters
            )
        }
        
        acceptObserver.sink { [weak self] filters in
            guard let self = self else { return }
            self.filters = filters
            self.filtersUpdated()
        }.store(in: &bag)
        
        observers
            .pushPaymentDetail
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushPaymentDetail(transaction: data)
            }.store(in: &bag)
        
        handle(viewModel.$transactions) { [weak self] data in
            guard let self = self else { return }
            skeleton.isAnimating = false
            self.transactionsData = data
            self.filters.paging.finished(paginator: data?.paginator)
            self.transactions.append(data?.transactions, self.filters.paging)
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.filters.paging.errorFinished()
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            loadingController(isLoading, self.table, self.transactions)
            tableReloader()
        }

        handle(viewModel.$transactionFeatures,
               showLoader: false) { [weak self] data in
            guard let self = self else { return }
            self.features = data
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showError(text: error?.message)
        }
        
        emptyPlaceholder.mainButtonClick { [weak self] in
            guard let self else { return }
            refreshList(refreshControl)
        }
        
        handle(crudCardViewModel.$changedCardsList, withError: false, success: { [weak self] _ in
            guard let self else { return }
            filters.paging.reset()
            initialRequest()
        })

    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("monitoring".localized())
        emptyPlaceholder.setupTitle("empty_monitoring".localized())
        emptyPlaceholder.setupButtonTitle("refresh".localized())
        actionsHeader.languageUpdated()
        calculateTotal()
        table.reloadData()
    }
    
    public override func initialRequest() {
        viewModel.loadTransactions(filters: filters)
        viewModel.loadTransactionFeatures()
    }
    
    func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: filters.paging, list: transactions) else { return }
        viewModel.loadTransactions(filters: filters)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        filters.paging.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    public func filtersUpdated() {
        filters.paging.reset()
        skeleton.isAnimating = true
        viewModel.loadTransactions(filters: filters)
    }
    
    public func calculateTotal() {
        totalHeader.setup(dateFrom: filters.from,
                          dateTo: filters.to,
                          amount: transactionsData?.total)
    }
    
    public func tableReloader() {
        checkPlaceholder()
        table.reloadData()
    }
    
    public func checkPlaceholder() {
        guard skeleton.isAnimating == false else {
            emptyPlaceholder.isHidden = true
            return
        }
        emptyPlaceholder.isHidden = !transactions.isEmpty
    }
}


