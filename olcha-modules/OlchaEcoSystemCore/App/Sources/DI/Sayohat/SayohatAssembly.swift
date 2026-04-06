import Swinject

final class SayohatAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(EcoSayohatViewController.self) { r in
            return EcoSayohatViewController()
        }
    }
    
}
