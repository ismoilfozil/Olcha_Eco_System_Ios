import UIKit
import Swinject
import OlchaUtils

public final class SplashScreenAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(SplashScreenViewController.self) { _ in
            return SplashScreenViewController()
        }
    }
    
}
