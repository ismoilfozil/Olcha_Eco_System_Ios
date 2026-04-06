import UIKit
import Swinject
import OlchaUtils

public final class SettingsAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(SettingsCoordinatorProtocol.self) { (r, navigationController: UINavigationController) in
            MainActor.assumeIsolated { SettingsCoordinator(navigationController: navigationController) }
        }

        container.register(SettingsViewController.self) { _ in
            MainActor.assumeIsolated { SettingsViewController() }
        }
    }

}
