import Foundation

struct AppState {
    
    static let lock = DispatchSemaphore(value: 1)
    nonisolated(unsafe) static private var isInBackground = false
    
    static var inBackground: Bool {
        get {
            lock.wait()
            let background = isInBackground
            lock.signal()
            return background
        }
        
        set(value) {
            lock.wait()
            isInBackground = value
            lock.signal()
        }
    }
}
