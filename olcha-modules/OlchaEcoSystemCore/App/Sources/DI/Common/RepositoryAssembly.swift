import Swinject
import OlchaCore

final class RepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.register(BuildRepositoryProtocol.self) { resolver in
            let manager = resolver.resolve(NetworkManagerProtocol.self)!
            return BuildRepository(manager: manager)
        }

        container.register(BarcodeRepositoryProtocol.self) { _ in
            return BarcodeRepository()
        }
    }

}
