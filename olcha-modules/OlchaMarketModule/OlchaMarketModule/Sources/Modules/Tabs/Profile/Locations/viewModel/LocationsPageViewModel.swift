//
//  LocationsPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import Combine
import OlchaUI
import OlchaAuth
import OlchaCore
public class LocationsPageViewModel: OldBaseViewModel {
    @Published var userAddressListData: LoadingState<UserAddressListData, BaseErrorType> = .standart
    @Published var districts: [District]?
    @Published var regions: [District]?
    @Published var savedAddress: UserAddress?
    @Published var addressSaveError: Bool = false
    
    public init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func loadUserLocations(page: Int) {
        let api: LocationAPI = .usersLocations(page: page)
        userAddressListData = .loading
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: UserAddressListData?) in
            guard let self else { return }
            self.userAddressListData = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            self.userAddressListData = .failure(.init(message: error))
        }
    }
    
    func makeDefault(addressID: Int) {
        let api: LocationAPI = .makeDefault(id: addressID)
        self.startRequesting(api: api) { (data: EmptyData?) in }
    }
    
    func delete(addressID: Int) {
        let api: LocationAPI = .delete(id: addressID)
        self.startRequesting(api: api) { (data: EmptyData?) in } onError: { message in }
    }
    
    func loadRegions() {
        let api: LocationAPI = .regions
        self.startRequesting(api: api) { [weak self] (data: DistrictsData?) in
            guard let self = self else { return }
            self.regions = data?.districts
        }
    }
    
    func loadDistricts(regionID: Int) {
        let api: LocationAPI = .districts(regionID: regionID)
        self.startRequesting(api: api) { [weak self] (data: DistrictsData?) in
            guard let self = self else { return }
            self.districts = data?.districts
        }
    }
    
    func saveAddress(_ address: UserAddress) {
        let api: LocationAPI
        
        if let id = address.id {
            api = .update(id: id, address: address)
        } else {
            api = .create(address: address)
        }
        
        self.startRequesting(api: api) { [weak self] (data: UserAddressData?) in
            guard let self = self else { return }
            
            self.savedAddress = data?.address ?? data?.new_address
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.show(error: message)
            self.addressSaveError = true
        }
    }
    
    
}
