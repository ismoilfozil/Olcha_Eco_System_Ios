import Foundation
import Network
import Combine

public final class NetworkMonitor: @unchecked Sendable {
    
    nonisolated(unsafe) public static let `default` = NetworkMonitor()
    
    public let statusSubject = CurrentValueSubject<Bool, Never>(true)
    
    private let queue = DispatchQueue(label: "com.olcha.OlchaUtils.network-monitor-queue")
    private let monitor: NWPathMonitor
    
    public var currentPath: NWPath {
        monitor.currentPath
    }
    
    public var isOnline: Bool {
        switch currentPath.status {
        case .satisfied:
            return true
        case .unsatisfied, .requiresConnection:
            return false
        @unknown default:
            return false
        }
    }
    
    private init() {
        monitor = NWPathMonitor()
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            let isOnline = path.status == .satisfied
            DispatchQueue.main.async { [weak self] in
                self?.statusSubject.send(isOnline)
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
    
}
