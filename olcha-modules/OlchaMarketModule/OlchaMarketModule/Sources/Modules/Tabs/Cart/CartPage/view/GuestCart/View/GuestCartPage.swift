//
//  GuestCartPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 29/01/24.
//

import UIKit
import OlchaUI

class GuestCartPage: OlchaUI.BaseViewController<GuestCartNavigationBar> {
    
    weak var coordinator: CartCoordinatorProtocol?
    
    lazy var table: BaseTableView = {
        let table = BaseTableView()
        
        table.round(14, topCorner: true, bottomCorner: false)
        table.configure()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: CartProductRoom.self)
        table.registerClass(forCell: CartProductsHeaderRoom.self)
        table.clipsToBounds = true
        
        return table
    }()
    
    private let bottomSection: UIView = {
       let view = UIView()
        view.round(14, topCorner: true, bottomCorner: false)
        view.addShadow(location: .top, color: .black, opacity: 0.1, radius: 14)
        view.backgroundColor = .olchaWhite
        return view
    }()
    
    let calculationButton = GuestCalculationButton()
    
    let viewModels = ViewModelsFactory()
    
    let observers = CartObservers()
    
    let sections: [Section] = [
        .header,
        .products
    ]
    
    private let bottomSectionHeight: CGFloat = 64
    
    override func setupViews() {
        container.addSubview(table)
        container.addSubview(bottomSection)
        bottomSection.addSubview(calculationButton)
    }
    
    override func autolayout() {
        table.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        calculationButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.top.equalToSuperview().inset(10)
        }
        
        bottomSection.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(bottomSectionHeight)
        }
    }
    
    override func configureViews() {
        container.backgroundColor = CartStyle.backgroundColor
        navigationController?.navigationBar.isHidden = true
        table.contentInset = .init(top: 0, left: 0, bottom: bottomSectionHeight, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.disableShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.enableShadow()
    }
    
    override func languageUpdated() {
        
        placeholder.setupTitle("empty_cart".localized())
        placeholder.setupSubtitle("empty_cart_subtitle".localized())
        
        tableReloader()
    }
    
    override func setupObservers() {
        setupCartObservers()
        setupFactoryObservers()
        setupActionObservers()
        
    }
    
    override func initialRequest() {
        CartViewModel.shared.loadCartItems.send(true)
    }
    
    func tableReloader() {
        table.reloadData()
        setupProducts()
        navigationBar.setup(count: observers.products.count)
        observers.products.isEmpty ? enablePlaceholder() : disablePlaceholder()
    }
    
}
