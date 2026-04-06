import Foundation

public class SayohatAppConfigurator {
    
    public static let shared = SayohatAppConfigurator()
    
    private init() {}
    
    public weak var appCoordinator: SayohatAppCoordinatorProtocol?
    
    public var isModule: Bool = false
    
    public func baseConfigure() {}
}
