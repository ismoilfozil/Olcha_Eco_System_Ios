import Foundation
import OlchaUtils

@propertyWrapper
public struct EcoDefaults<T> {
    let key: String
    var storage: UserDefaults? = UserDefaults(suiteName: "olcha-eco-system")
    
    public var wrappedValue: T? {
        get {
            storage?.value(forKey: key) as? T
        }
        set {
            storage?.set(newValue, forKey: key)
        }
    }
}

public class EcoGlobalDefaults {
    public static let shared = EcoGlobalDefaults()
    
    private init() {}
    
    public struct search {
        @EcoDefaults(key: "histories") static var histories: [String]?
        
        static func add(history: String) {
            if EcoGlobalDefaults.search.histories == nil {
                EcoGlobalDefaults.search.histories = []
            }
            
            EcoGlobalDefaults.search.histories = EcoGlobalDefaults.search.histories?.reversed()
            
            if !(EcoGlobalDefaults.search.histories?.contains(history) ?? false) {
                EcoGlobalDefaults.search.histories?.append(history)
            }
            
            if EcoGlobalDefaults.search.histories?.count == 5 {
                EcoGlobalDefaults.search.histories?.removeFirst()
            }
            
            EcoGlobalDefaults.search.histories = EcoGlobalDefaults.search.histories?.reversed()
        }
        
        static func remove(index: Int) {
            if index < (EcoGlobalDefaults.search.histories?.count ?? 0) {
                EcoGlobalDefaults.search.histories?.remove(at: index)
            }
        }
        
        static func removeAll() {
            EcoGlobalDefaults.search.histories?.removeAll()
        }
    }
}
