//
//  StreetMapViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 09/09/22.
//

import Foundation
import CoreLocation
import OlchaUI
import OlchaCore
import OlchaAuth
class StreetMapViewModel: OldBaseViewModel {
    
    @Published var searchedLocations: [StreetMapLocationModel] = []
    
    @Published var currentLocation: StreetMapLocationModel?
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func searchLocation(text: String) {
        let api: StreetMapAPI = .search(text)
        self.startRequesting(api: api,
                             isCancellable: true,
                             isSingleRequest: true) { [weak self] (data: [StreetMapLocationModel]?) in
            guard let self = self else { return }
            self.searchedLocations = data ?? []
        } onError: { message in }
    }
    
    func loadLocation(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude,
              let longitude = longitude else {
                  return
              }
        
        let api: StreetMapAPI = .loadName(latitude: latitude, longitude: longitude)
        self.startRequesting(api: api,
                             isCancellable: true,
                             isSingleRequest: true) { [weak self] (data: StreetMapLocationModel?) in
            guard let self = self else { return }
            self.currentLocation = data
        } onError: { message in }

    }
    
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D {
        .init(latitude: (currentLocation?.lat ?? "0").double,
              longitude: (currentLocation?.lon ?? "0").double)
    }
    
}
