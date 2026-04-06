import Swinject
import OlchaUtils

public final class LanguageAssembly: Assembly {

    public func assemble(container: Container) {
        container.register(LanguageViewController.self) { _ in
            return LanguageViewController()
        }
    }
    
}
