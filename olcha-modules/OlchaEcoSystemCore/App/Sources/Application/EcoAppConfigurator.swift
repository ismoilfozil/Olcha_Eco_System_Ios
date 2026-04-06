import UIKit
import OlchaUI
import OlchaUtils
import OlchaCommon

public class EcoAppConfigurator {
    
    public static let shared = EcoAppConfigurator()
    
    private init() {}
    
    public weak var appCoordinator: EcoAppCoordinatorProtocol?
    
    public var isModule: Bool = false
    
    public func baseConfigure() {
        UITableView.defaultBundle = .olchaEcoSystemCore
        UINavigationController.tabless = true
        
        
        OnboardingConfigurator.configure(
            languages: [.oz, .ru],
            bundleType: .olchaEcoSystemCore,
            application: .ecosystem,
            pages: 5,
            isSubtitleHidden: true,
            isLeftButtonHidden: true,
            isRightButtonHidden: true,
            isLogoHidden: false,
            group_bundle_name: Texts.groupUrls.ecoSystem
        )
        
        CommonConfigurator.shared.tabNames =  EcoSystemTexts.tabNames
        CommonConfigurator.shared.bundle = .olchaEcoSystemCore
        
    }
}

