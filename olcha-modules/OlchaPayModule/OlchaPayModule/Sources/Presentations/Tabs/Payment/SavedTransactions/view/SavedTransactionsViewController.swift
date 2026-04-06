//
//  SavedTransactionsViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/04/23.
//

import UIKit
import OlchaCore
import OlchaUI
public class SavedTransactionsViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: SavedTransactionItem.self)
        collection.alwaysBounceVertical = true
        return collection
    }()
    
    var transactions: [SavedTransactionModel] = []
    var paging = Paging()
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    public let viewModel: SavedTransactionsViewModel
    
    public init(viewModel: SavedTransactionsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(collection)
        collection.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("saved_transactions".localized())
    }
    
    public override func initialRequest() {
        initialLoad()
    }
    
    public override func setupObservers() {
        handle(viewModel.$savedTransactions) { [weak self] data in
            guard let self = self else { return }
            
            self.paging.finished(paginator: data?.paginator)
            self.transactions.append(data?.saved_transactions, self.paging)
            self.collection.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.paging.errorFinished()
            self.showError(text: error?.message)
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            self.loadingController(isLoading,
                                   self.collection,
                                   self.transactions)
        }
        
    }
    
    public override func refreshList(_ sender: AnyObject) {
        initialLoad()
        refreshControl.endRefreshing()
    }
    
    private func initialLoad() {
        paging.reset()
        viewModel.loadSavedTransactions(page: paging.current)
    }
    
    public func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: transactions) else { return }
        
        viewModel.loadSavedTransactions(page: paging.current)
    }
    
    public func deleteTransaction(at indexPath: IndexPath) {
        guard transactions.isGreater(indexPath) else { return }
        guard let id = transactions[indexPath.item].id else { return }
        viewModel.deleteTransaction(id: id)
        
        transactions.remove(at: indexPath.item)
        collection.reloadData()
    }
    
    public func editTransaction(model: SavedTransactionModel?) {
        coordinator?.pushEditTransaction(id: model?.id)
    }
}
