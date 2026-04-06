import Swinject

final class UseCaseAssembly: Assembly {
    
    public func assemble(container: Container) {
        let assemblies: [Assembly] = [
            HomeUseCaseAssembly(),
            SearchUseCaseAssembly(),
        ]
        assemblies.forEach({ $0.assemble(container: container) })
    }
    
}
