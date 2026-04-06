//
//  NewsListPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import Combine
import OlchaUI
import OlchaCore
class NewsListPage: BaseViewController {

    private let viewModel = HomePageViewModel()
    
    private var bag = Set<AnyCancellable>()
    
    let paginator = Paging()
    
    var blogs: [Blog] = []

    let collection = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var coordinator: HomeCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(collection)
    }
    
    override func autolayout() {
        super.autolayout()
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("news".localized())
        
        collection.backgroundColor = .olchaBackgroundColor
        collection.delegate = self
        collection.dataSource = self
        collection.registerClass(forCell: NewsCardItem.self)
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    override func initialRequest() {
        super.initialRequest()
        loadBlogs()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$blogsData
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.paginator.total = data?.paginator?.last_page ?? 1
                self.paginator.current = data?.paginator?.current_page ?? 1
                self.paginator.isLoading = false
                
                self.blogs.append(contentsOf: data?.blogs ?? [])
                
                self.collection.reloadData()
            }.store(in: &bag)
        
        viewModel
            .$blogsError
            .dropFirst()
            .sink { [weak self] isError in
                guard let self = self,
                      let isError = isError else { return }
                if isError {
                    self.paginator.isLoading = false
                    self.paginator.current -= 1
                }
            }.store(in: &bag)
    }
    
    func checkPaginator(index: Int) {
        if index == (blogs.count - 3) {
            if !paginator.isLoading {
                paginator.current = paginator.current + 1
                if paginator.current <= paginator.total {
                    loadBlogs()
                }
            }
        }
    }
    
    func loadBlogs() {
        viewModel.loadBlogs(page: paginator.current)
    }

}
