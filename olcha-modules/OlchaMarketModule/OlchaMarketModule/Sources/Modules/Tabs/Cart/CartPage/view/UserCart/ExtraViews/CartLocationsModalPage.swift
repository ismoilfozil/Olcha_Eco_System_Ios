//
//  CartLocationsModalPage.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 04/02/24.
//

import UIKit
import OlchaUI
import PanModal
class CartLocationsModalPage: BaseModalViewController {
    
    private lazy var table: DynamicTable = {
        let table = DynamicTable()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: CartLocationRoom.self)
        table.registerClass(forCell: CartAddLocationRoom.self)
        table.configure()
        return table
    }()
    
    private let saveButton: OlchaButton = {
        let button = OlchaButton()
        return button
    }()
    
    var locations: [UserAddress] = []
    
    let itemHeight: CGFloat = 118.0
    
    weak var observers: CartObservers?
    
    weak var locationsViewModel: LocationsPageViewModel?
    
    var selectedAddress: UserAddress? {
        didSet {
            table.reloadData()
        }
    }
    
    var locationsCount: Int {
        let count = locations.count
        return skeleton?.getCount(count) ?? count
    }
    
    var skeleton: Skeleton? {
        observers?.skeleton.locations
    }
    
    weak var coordinator: CartCoordinatorProtocol?
    
    override func setupViews() {
        container.addSubview(table)
        container.addSubview(saveButton)
    }
    
    override func autolayout() {
        
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
            make.top.equalTo(table.snp.bottom).inset(-16)
        }
        
    }
    
    override func configureViews() {
        xButton.isHidden = true
        staticTexts()
    }
    
    override func setupObservers() {
        saveButton.clicked { [weak self] in
            guard let self else { return }
            observers?.selectedAddress = selectedAddress
            observers?.action.addressSelected.send()
            dismiss(animated: true)
        }
    }
    
    func setup(selectedAddress: UserAddress?) {
        if let selectedAddress = selectedAddress {
            self.selectedAddress = selectedAddress
        } else if let address = locations.first(where: { $0.isMainAddress() }) {
            self.selectedAddress = address
        } else {
            self.selectedAddress = locations.first
        }
    }
    
    func updateLayout() {
        table.reloadData()
    }
    
    func staticTexts() {
        setHeader(title: "ship_address".localized())
        saveButton.setTitle("save".localized())
        
    }

    override func setupOptionalObservers() {
        selectedAddress = observers?.selectedAddress
        
        guard let locationsViewModel else { return }
        handle(locationsViewModel.$userAddressListData) { [weak self] data in
            guard let self else { return }
            setupLocations(data?.data ?? [])
        } loading: { [weak self] isLoading in
            guard let self else { return }
            setLocationsSkeletonAnimating(isLoading)
        }
    }
    
    override func setupOptionalInitialRequests() {
        locationsViewModel?.loadUserLocations(page: 1)
    }

    
}

extension CartLocationsModalPage: PanModalPresentable {
    var panScrollable: UIScrollView? {
        table
    }
}

extension CartLocationsModalPage {
    
    func setLocationsSkeletonAnimating(_ isLoading: Bool) {
        if locations.isEmpty {
            skeleton?.isAnimating = isLoading
        } else {
            skeleton?.isAnimating = false
        }
        table.reloadData()
    }
    
    func setupLocations(_ data: [UserAddress]) {
        observers?.locations = data
        locations = data
        setup(selectedAddress: selectedAddress)
        updateLayout()
    }
}
