import OlchaUtils

public class CommonConfigurator {
    
    nonisolated(unsafe) public static let shared = CommonConfigurator()
    
    private init() {}
    
    public weak var moduleCoordinator: CommonCoordinatorProtocol?
    
    public var isModule: Bool = true
    public var tabNames: [String] = []
    public var bundle: BundleType = .resources
    
}
