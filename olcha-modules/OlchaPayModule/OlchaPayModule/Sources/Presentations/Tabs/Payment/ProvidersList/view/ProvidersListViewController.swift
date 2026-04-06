//
//  PaymentsListViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 12/02/23.
//

import UIKit
import OlchaCore
import OlchaUI
public class ProvidersListViewController: BaseViewController<BackNavigationBar> {

    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: PaymentTypeRoom.self)
        table.registerClass(forHeaderFooter: PaymentTypeHeader.self)
        
        return table
    }()
    
    let sections: [Section] = [
        .providers,
        .loading
    ]
    
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    public let observerHelper = PushPaymentHelper()
    
    public var category: CategoryModel?
    
    public let skeleton = Skeleton(count: 12)
    
    public var providers: [ProviderModel] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    let paging = Paging()
    
    let viewModel: PaymentsViewModel
    
    public init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func setupViews() {
        container.addSubview(table)
        table.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle(category?.getTitle())
        navigationBar.searchButton.isHidden = false
    }
    
    public override func setupObservers() {
        observerHelper
            .pushPayment
            .sink { [weak self] isPushing in
                guard let self = self, isPushing else { return }
            
            }.store(in: &bag)
        
        handle(viewModel.$providersWithCategory) { [weak self] data in
            guard let self = self else { return }
            self.paging.finished(paginator: data?.paginator)

            self.providers.append(data?.providers, self.paging)
            self.table.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.paging.errorFinished()
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.paging.isLoading = isLoading
            self.skeleton.initialSkeleton(isAnimating: isLoading, paging)
            self.table.reloadData()
//            self.loadingController(isLoading,
//                                   self.table,
//                                   self.providers)
        }
        
        navigationBar.searchButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushSearch(categoryID: category?.id)
        }
    }
    
    public override func initialRequest() {
        viewModel.loadProviders(category: category, page: 1)
    }
    
    func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: providers) else { return }
        viewModel.loadProviders(category: category, page: paging.current)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        paging.reset()
        providers.removeAll()
        initialRequest()
        refreshControl.endRefreshing()
    }
}
