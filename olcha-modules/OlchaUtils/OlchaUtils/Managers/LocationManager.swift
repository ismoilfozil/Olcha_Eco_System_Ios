import CoreLocation

public final class LocationManager: NSObject {
    
    nonisolated(unsafe) public static let `default` = LocationManager()
    
    @Published public var status: CLAuthorizationStatus = .notDetermined
    
    public var currentLocation: CLLocation? {
        startUpdatingLocation()
        defer {
            stopUpdatingLocation()
        }
        return locationManager.location
    }
    
    public var currentLocationCoordinate: CLLocationCoordinate2D? {
        startUpdatingLocation()
        defer {
            stopUpdatingLocation()
        }
        return locationManager.location?.coordinate
    }
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
    }
}
