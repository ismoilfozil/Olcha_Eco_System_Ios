import Foundation
import OlchaUtils

@propertyWrapper
public struct CommonDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-common")
    
    public var wrappedValue: T? {
        get {
            storage?.value(forKey: key) as? T
        }
        set {
            storage?.set(newValue, forKey: key)
        }
    }
}

public class CommonGlobalDefaults {
    nonisolated(unsafe) private static let storage = UserDefaults(suiteName: "olcha-common")

    public struct settings {
        public static var pushNotificationsEnabled: Bool? {
            get { CommonGlobalDefaults.storage?.value(forKey: "push_notifications") as? Bool }
            set { CommonGlobalDefaults.storage?.set(newValue, forKey: "push_notifications") }
        }
    }

    public struct session {
        public static var isEntered: Bool? {
            get { CommonGlobalDefaults.storage?.value(forKey: "is_entered") as? Bool }
            set { CommonGlobalDefaults.storage?.set(newValue, forKey: "is_entered") }
        }
    }
}
