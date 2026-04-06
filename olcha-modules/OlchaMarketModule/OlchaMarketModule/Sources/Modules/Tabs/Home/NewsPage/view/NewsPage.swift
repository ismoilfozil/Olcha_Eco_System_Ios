//
//  NewsPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 06/09/22.
//

import UIKit
import OlchaUI
import Combine
class NewsPage: BaseViewController {

    enum Section {
        case title
        case newsData
        case image
        case content
    }
    
    let sections: [Section] = [
        .title,
        .newsData,
        .image,
        .content
    ]
    
    let table = BaseTableView()
    
    private let viewModel = HomePageViewModel()
    
    private let catalogViewModel = CatalogPageViewModel()
    
    private var bag = Set<AnyCancellable>()
    
    var blog: Blog?
    
    var products: ProductsData?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("news".localized())
        
        
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: NewsTitleRoom.self)
        table.registerClass(forCell: NewsDataRoom.self)
        table.registerClass(forCell: NewsImageRoom.self)
        table.registerClass(forCell: NewsContentRoom.self)
        
    }
    
    override func initialRequest() {
        super.initialRequest()
        guard let id = blog?.id else { return }
        viewModel.loadBlog(with: id)
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        viewModel
            .$blog
            .dropFirst()
            .sink { [weak self] data in
                guard let self = self else { return }
                self.blog = data
                self.table.reloadData()
            }.store(in: &bag)
        
    }
    
    
    
}
