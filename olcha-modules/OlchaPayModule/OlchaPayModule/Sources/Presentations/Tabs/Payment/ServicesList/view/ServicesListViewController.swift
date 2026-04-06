//
//  ServicesListViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 27/03/23.
//

import UIKit
import OlchaUI
public class ServicesListViewController: BaseViewController<BackNavigationBar> {
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.configure()
        table.registerClass(forCell: PaymentTypeRoom.self)
        return table
    }()
    
    var provider: ProviderModel? {
        didSet {
            services = provider?.service ?? []
        }
    }
    
    var services: [ServiceModel] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    var providerId: Int?
    let viewModel: PaymentsViewModel
    weak var coordinator: PaymentsCoordinatorProtocol?
    
    public init(viewModel: PaymentsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(table)
    }
    
    public override func autolayout() {
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle(provider?.title_short)
        navigationBar.searchButton.isHidden = false
    }
    
    public override func initialRequest() {
        guard let providerId else { return }
        viewModel.loadProvider(id: providerId)
    }
    
    public override func setupObservers() {
        handle(viewModel.$provider, showLoader: true, success: { [weak self] data in
            guard let self else { return }
            provider = data?.providers
        })
        
        navigationBar.searchButton.clicked { [weak self] in
            guard let self else { return }
            coordinator?.pushSearch(categoryID: nil)
        }
    }
    
}
