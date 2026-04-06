//
//  NewsListViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 16/02/23.
//

import UIKit
import OlchaUI
import PinterestLayout
import OlchaCore
public class NewsListViewController: BaseViewController<BackNavigationBar> {
    
    lazy var collection: UICollectionView = {
        let layout = getPinterestLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        
        collection.registerClass(forCell: NewsListItem.self)
        
        return collection
    }()
    
    weak var coordinator: PayHomeCoordinatorProtocol?
    
    private let viewModel: NewsViewModel
    
    public init(newsViewModel: NewsViewModel) {
        self.viewModel = newsViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var news: [NewsModel] = [] {
        didSet {
            collection.reloadData()
        }
    }
    
    let paging = Paging()
    
    public override func setupViews() {
        container.addSubview(collection)
        collection.addSubview(refreshControl)
    }
    
    public override func autolayout() {
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        placeholder.setupImage(.empty_news)
        languageUpdated()
    }
    
    public override func languageUpdated() {
        navigationBar.setTitle("news".localized())
        placeholder.setupTitle("empty_news".localized())
    }
    
    public override func initialRequest() {
        viewModel.loadImages(page: 1)
    }
    
    public override func setupObservers() {
        
        handle(viewModel.$newsData, showLoader: true) { [weak self] data in
            guard let self = self else { return }
            self.paging.finished(paginator: data?.paginator)
            self.news.append(data?.news ?? [], self.paging)
            collectionReloader()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.paging.errorFinished()
            collectionReloader()
        } loading: { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? showLoader() : hideLoader()
        }

    }
    
    
    private func getPinterestLayout() -> PinterestLayout {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.cellPadding = 5
    
        layout.numberOfColumns = 2
        return layout
    }
    
    func loadMore(_ index: Int) {
        guard canLoad(index: index, paging: paging, list: news) else { return }
     
        viewModel.loadImages(page: paging.current)
    }
    
    public override func refreshList(_ sender: AnyObject) {
        paging.reset()
        initialRequest()
        refreshControl.endRefreshing()
    }
    
    private func checkPlaceholder() {
        news.isEmpty ? enablePlaceholder() : disablePlaceholder()
    }
    
    public func collectionReloader() {
        checkPlaceholder()
        collection.reloadData()
    }
}
