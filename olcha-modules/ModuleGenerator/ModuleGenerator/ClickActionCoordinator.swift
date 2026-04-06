import Foundation
import OlchaUI
import OlchaUtils
///
/// - ``ClickActionCoordinator`` is generates modules with clickaction(notification, deeplink))
///
public class ClickActionCoordinator {
    
    public static var waitTime: TimeInterval = 0
    
    public static func clickActionRouter(action: ClickAction) {
        if let module = action.module {
            ModuleGenerator.shared.generate(module: module) {
                DispatchQueue.main.asyncAfter(deadline: .now() + ClickActionCoordinator.waitTime) {
                    let coordinator: AppCoordinatorProtocol? = ModuleGenerator.shared.getCurrentCoordinator()
                    coordinator?.clickActionRouter(action: action)
                }
            }
        }
        
        if let action = action as? WebviewClickAction {
            switch action {
            case .webview(let deeplink):
                FuncsManager.openURL(deeplink)
            }
        }
    }
    
}
