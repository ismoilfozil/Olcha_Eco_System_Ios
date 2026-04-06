//
//  SearchViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 03/04/23.
//
import OlchaCore
import Combine
import UIKit
import OlchaUI
public class SearchViewController: BaseViewController<SearchNavigationBar>, UITextFieldDelegate {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: PaymentTypeRoom.self)
        return table
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaTextBlack
        label.textAlignment = .center
        
        label.numberOfLines = 0
        label.text = "not_found".localized()
        label.isHidden = true
        return label
    }()
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    var searchText: String? = "" {
        didSet {
            paging.reset()
            resetTable()
        }
    }
    
    let textFieldObserver = PassthroughSubject<Void, Never>()
    
    var providers: [ProviderModel] = []
    
    var paging = Paging()
    
    let viewModel: SearchViewModel
    
    var categoryID: Int?
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
        container.addSubview(emptyLabel)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
        }
    }
    
    public override func configureViews() {
        navigationBar.searchView.setPlaceholder("search".localized())
        textField().returnKeyType = .search
    }
    
    public override func setupObservers() {
            
        textField().addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        handle(viewModel.$providers,
               showLoader: true,
               success: { [weak self] data in
            guard let self = self else { return }
            loadFinished(data)
        }, failure: { [weak self] error in
            guard let self = self else { return }
            showError(text: error?.message)
        }, loading: { [weak self] isLoading in
            guard let self = self else { return }
            paging.isLoading = isLoading
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchProviders()
    }
    
    public func textField() -> UITextField {
        navigationBar.searchView.textField
    }

    func searchProviders() {
        
        paging.isLoading = true
        viewModel.search(page: paging.current,
                         searchText: textField().text,
                         categoryID: categoryID)
        
    }
    
    func loadMoreProviders(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: providers) else { return }
        viewModel.search(page: paging.current,
                         searchText: textField().text,
                         categoryID: categoryID)
    }
    
    private func loadFinished(_ data: ProvidersData?) {
        paging.finished(paginator: data?.paginator)

        providers.append(data?.providers, paging)
        table.reloadData()
        emptyLabel.isHidden = !providers.isEmpty
    }
    
    private func resetTable() {
        providers.removeAll()
        emptyLabel.isHidden = !providers.isEmpty
        table.reloadData()
    }
}
