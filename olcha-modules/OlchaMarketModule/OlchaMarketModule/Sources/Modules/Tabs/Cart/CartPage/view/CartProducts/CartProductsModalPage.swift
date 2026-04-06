//
//  CartProductsModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 15/02/24.
//

import UIKit
import OlchaUI
import Combine

class CartProductsModalPage: BaseViewController, ModalPageType {
    private var bag = Set<AnyCancellable>()
    lazy var table: BaseTableView = {
       let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: CartProductRoom.self)
        table.configure()
        return table
    }()
    
    private let closeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("close".localized())
        return button
    }()
    
    weak var coordinator: CartCoordinatorProtocol?
    weak var observers: CartObservers? {
        didSet {
            setupOptionalObservers()
            setupOptionalInitialRequests()
        }
    }
    weak var checkoutViewModel: CheckoutViewModel?
    
    override func viewDidLoad() {
        
        setupModalViews()
        modalAutolayout()
        configureModalViews(header: "products".localized())
        setupObservers()
        initialRequest()
        baseObservers()
    }
    
    override func setupModalViews() {
        super.setupModalViews()
        modalContainer.addSubview(table)
        modalContainer.addSubview(closeButton)
    }
    
    override func modalAutolayout() {
        super.modalAutolayout()
        table.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(table.snp.bottom).inset(-16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func setupObservers() {
        super.setupObservers()
        closeButton.clicked { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
        }
    }
    
    func setupOptionalInitialRequests() {
        table.reloadData()
    }
    
    func setupOptionalObservers() {
        
        guard let checkoutViewModel else { return }
        handle(checkoutViewModel.$cartProducts, loading: { [weak self] isLoading in
            guard let self else { return }
            setProductsSkeletonAnimating(isLoading)
        })
        observers?.action.productsUpdated.sink { [weak self] in
            guard let self else { return }
            tableReloader()
        }.store(in: &bag)
    }
    
    override func configureModalViews(header: String = "", textAlignment: NSTextAlignment = .left) {
        super.configureModalViews(header: "products".localized())
        self.dismissConfiguration()
        
        setContainerHeight()
    }
    
    func tableReloader() {
        table.reloadData()
    }
    
    func setProductsSkeletonAnimating(_ isLoading: Bool) {
        if (observers?.products.isEmpty ?? true) {
            observers?.skeleton.products.isAnimating = isLoading
        } else {
            observers?.skeleton.products.isAnimating = false
        }
        table.reloadData()
    }
    
}
