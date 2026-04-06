import Swinject
import OlchaCommon
import UIKit

public final class OnboardingAssembly: Assembly {
 
    public func assemble(container: Container) {
        container.register(CommonCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            OnboardingConfigurator.configure(bundleType: .olchaInvestCore,
                                             application: .invest,
                                             pages: 4,
                                             group_bundle_name: InvestTexts.groupBundle)
            
            return CommonCoordinator(navigationController: navigationController)
        }   
    }
    
}
