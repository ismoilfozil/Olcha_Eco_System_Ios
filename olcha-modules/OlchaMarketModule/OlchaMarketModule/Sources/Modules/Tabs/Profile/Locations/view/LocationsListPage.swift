//
//  LocationsListPage.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import UIKit
import OlchaUI
import Combine
import OlchaCore
class LocationsListPage: BaseViewController {

    private var bag = Set<AnyCancellable>()

    let viewModel = LocationsPageViewModel()
    
    let table = BaseTableView()
    
    let newAddressButton = LeftIconButton()
    
    public var paging = Paging()
    
    var locationsList: [UserAddress] = []
    
    weak var coordinator: ProfileCoordinatorProtocol?
    
    override func setupViews() {
        super.setupViews()
        container.addSubview(table)
        container.addSubview(newAddressButton)
    }
    
    override func autolayout() {
        super.autolayout()
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newAddressButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        navigation.configure(style: .back)
        navigation.setTitle("addresses".localized())
        table.configure()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: LocationCardRoom.self)
        table.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        
        newAddressButton.backgroundColor = .olchaAccentColor
        newAddressButton.round()
        newAddressButton.setTitle("add_new_address".localized())
        newAddressButton.setIcon(.plus?.withColor(.olchaWhite), iconSize: 20)
        newAddressButton.titleLabel.textColor = .olchaWhite
        newAddressButton.shadowAdd(offset: .zero, color: .black.withAlphaComponent(0.2), opacity: 1, radius: 16)
    }
    
    override func initialRequest() {
        super.initialRequest()
        loadMore()
    }
    
    override func setupObservers() {
        super.baseSetupObservers(viewModel: viewModel)
        
        handle(viewModel.$userAddressListData,
               showLoader: true,
               success: { [weak self] data in
            guard let self else { return }
            self.paging.finished(paginator: data?.paginator)
            self.locationsList.append(contentsOf: data?.data ?? [])
            self.table.reloadData()
        })
        
        newAddressButton
            .settings
            .clicked { [weak self] in
                guard let self = self else { return }
                self.coordinator?.pushAddLocationMap(address: nil) {
                    self.restartLoading()
                }
            }
    }
    
    func loadMore() {
        viewModel.loadUserLocations(page: paging.current)
    }
    
    func deleteAddress(id: Int) {
        viewModel.delete(addressID: id)
    }
    
    func makeDefaultAddress(id: Int) {
        viewModel.makeDefault(addressID: id)
    }
    
    private func restartLoading() {
        paging.reset()
        locationsList.removeAll()
        loadMore()
    }
    
}
