import Foundation
import OlchaUtils

extension NasiyaHomeViewController {
    public func bannerObserver(action: ClickAction?) {
        guard let action else { return }
        ModuleGeneratorHelper.shared.performAction(action: action)
    }
}
