import UIKit
import Combine
import OlchaUI
import OlchaCore

class MyOrdersPage: BaseViewController, ButtonMenusDelegate {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: MyOrderRoom.self)
        table.registerClass(forCell: EmptyPlaceholderRoom.self)
        return table
    }()
    private let headerContainer = UIView()
    private let sortButton: HButtonIcon = {
        let button = HButtonIcon()
        button.setTitle(" ")
        button.round(8)
        button.darkBorder()
        button.setIcon(.down_anchor_black?.withTintColor(.olchaAccentColor, renderingMode: .alwaysOriginal))
        return button
    }()
    
    var orders: [Order] = []
    
    private var paging = Paging()
    
    private var bag = Set<AnyCancellable>()
    
    let viewModel = OrderPageViewModel()
    
    var selectedSortItem: MyOrdersSortItem = .all {
        didSet {
            sortButton.setTitle(selectedSortItem.text)
            loadHistory()
        }
    }
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    let tableReloader = PassthroughSubject<Bool, Never>()
    
    let productHelper = ProductHelper()
    
    var state: PageState = .default {
        didSet {
            table.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        container.addSubview(headerContainer)
        headerContainer.addSubview(sortButton)
        setupSortMenus()
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerContainer.snp.bottom).inset(-8)
        }
        
        headerContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.left.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        sortButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("my_orders".localized())
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        sortMenus?.delegate = self
        viewModel
            .$ordersHistoryData
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.paging.finished(paginator: data?.paginator)
                self.orders.append(data?.orders, paging)
                state = .loaded
            }.store(in: &bag)
        
        viewModel
            .$ordersHistoryError
            .dropFirst()
            .sink { [weak self] isError in
                guard let self = self else { return }
                self.paging.current -= 1
                self.paging.isLoading = true
                state = .loaded
            }.store(in: &bag)
        
        sortButton.clicked { [weak self] in
            guard let self = self else { return }
            self.sortButtonClicked()
        }
        
        viewModel
            .$orderCanceled
            .sink { [weak self] isCanceled in
                guard let self = self, isCanceled else { return }
                self.loadHistory()
            }.store(in: &bag)
        
        viewModel
            .$myOrdersIsLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
//                table.reloadData()
            }.store(in: &bag)
        
        tableReloader.sink { [weak self] isReloading in
            guard let self = self, isReloading else { return }
            self.table.reloadData()
        }.store(in: &bag)
        
        productHelper
            .pushProduct
            .sink { [weak self] data in
                guard let self = self else { return }
                self.coordinator?.pushProduct(product: data)
            }.store(in: &bag)
    }
    
    override func initialRequest() {
        selectedSortItem = .all
    }
    
    private func sortButtonClicked() {
        openMenus(with: MarketTexts.sort.myOrders,
                  sender: sortButton,
                  selectedSort: selectedSortItem)
    }
    
    func selected(sort: SortItem) {
        hideMenus()
        guard let sort = sort as? MyOrdersSortItem,
              selectedSortItem != sort else { return }
        selectedSortItem = sort
    }
    
}

extension MyOrdersPage {
    fileprivate func loadHistory() {
        paging.reset()
//        orders.removeAll()
        state = .loading
        loadHistoryRequest()
    }
    
    func loadMore(index: Int) {
        guard canLoad(index: index, paging: paging, list: orders) else { return }
        state = .paginating
        loadHistoryRequest()
    }
    
    private func loadHistoryRequest() {
        viewModel.loadMyOrders(page: paging.current,
                               status: selectedSortItem)
    }
}
