import UIKit
import OlchaUI
import OlchaBalance
import OlchaCommon
import OlchaAuth
import OlchaMarketModule
import OlchaUtils

public protocol EcoMainCoordinatorProtocol: Coordinator {
    var homeCoordinator: EcoHomeCoordinatorProtocol { get set }
    var profileCoordinator: EcoProfileCoordinatorProtocol { get set }
    var searchCoordinator: EcoSearchCoordinatorProtocol { get set }
//    var menuCoordinator: MenuCoordinatorProtocol { get }
    func pushMarketAction()
}

public class EcoMainCoordinator: NSObject, EcoMainCoordinatorProtocol {
    
    public var navigationController: UINavigationController
    public lazy var homeCoordinator: EcoHomeCoordinatorProtocol = EcoHomeCoordinator(navigationController: navigationController)
    public lazy var profileCoordinator: EcoProfileCoordinatorProtocol = EcoProfileCoordinator(navigationController: navigationController)
    public lazy var commonCoordinator: CommonCoordinatorProtocol = CommonDIContainer.shared.resolve(argument: navigationController)
    public lazy var authCoordinator: AuthCoordinatorProtocol = AuthDIContainer.shared.resolve(argument: navigationController)
    
    public lazy var searchCoordinator: EcoSearchCoordinatorProtocol = EcoDIContainer.shared.resolve(argument: navigationController)
    
    public lazy var clickActionCoordinator: ClickActionCoordinatorProtocol = EcoDIContainer.shared.resolve(argument: navigationController)
    
//    public lazy var balanceCoordinator: BalanceCoordinatorProtocol = BalanceCoordinator(navigationController: navigationController)
//    public lazy var menuCoordinator: MenuCoordinatorProtocol = MenuCoordinator(navigationController: navigationController)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {}
    
    public func pushMarketAction() {
        clickActionCoordinator.clickActionRouter(action: MarketClickAction.cart)
    }
}
