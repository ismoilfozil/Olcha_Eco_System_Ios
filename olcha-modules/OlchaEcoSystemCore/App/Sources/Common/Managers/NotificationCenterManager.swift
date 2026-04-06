import Foundation

public protocol NotificationCenterManager {
    var notificationName: Notification.Name { get }
    func postNotification(senderObject: Any?)
    func addObserver(observer: Any, selector: Selector, object: Any?)
    func removeObserver(_ observer: Any, object: Any?)
}

public extension NotificationCenterManager {
    func postNotification(senderObject: Any? = nil) {
        NotificationCenter.default.post(name: notificationName, object: senderObject)
    }
    
    func addObserver(observer: Any, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: object)
    }
    
    func removeObserver(_ observer: Any, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: notificationName, object: object)
    }
}

public final class AuthNotificationManager: NotificationCenterManager {

    public static let shared = AuthNotificationManager()
    
    public var notificationName = Notification.Name("auth.notification")

}
