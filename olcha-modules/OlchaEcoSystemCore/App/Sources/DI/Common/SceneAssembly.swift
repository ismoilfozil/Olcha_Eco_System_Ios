import Swinject

final class SceneAssembly: Assembly {
    
    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            HomeAssembly(),
            SearchAssembly(),
            ProfileAssembly(),
            SayohatAssembly(),
            OrderConfirmationAssembly(),
        ]
        assemblies.forEach({ $0.assemble(container: container) })
    }
    
}
