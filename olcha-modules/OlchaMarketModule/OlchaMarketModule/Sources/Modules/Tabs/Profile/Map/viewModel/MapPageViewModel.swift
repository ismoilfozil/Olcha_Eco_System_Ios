//
//  MapPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 08/09/22.
//

import Foundation
import CoreLocation
//import YandexMapsMobile
import Combine
//
//class MapPageViewModel: NSObject, YMKMapCameraListener, CLLocationManagerDelegate {
//
//    private let manager = CLLocationManager()
//    
//    var currentLocation: CLLocationCoordinate2D?
//    
//    var mapLocation: CLLocationCoordinate2D?
//    
//    @Published var locationChanged: Bool = false
//    
//    let initialLocation = PassthroughSubject<Bool, Never>()
//    
//    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
//        mapLocation = CLLocationCoordinate2D(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
//        if finished {
//            locationChanged = true
//        }
//    }
//    
//    override init() {
//        super.init()
//        checkPermission()
//        manager.delegate = self
//        manager.startUpdatingLocation()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func checkPermission() {
//        manager.requestWhenInUseAuthorization()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.currentLocation = locations.last?.coordinate
//        initialLocation.send(completion: .finished)
//    }
//    
//}
