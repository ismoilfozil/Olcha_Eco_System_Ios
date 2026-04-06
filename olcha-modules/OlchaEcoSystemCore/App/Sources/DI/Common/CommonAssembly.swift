import Swinject
import OlchaCore
import Alamofire

final class CommonAssembly: Assembly {
 
    public func assemble(container: Container) {
        container.register(RequestInterceptor.self) { _ in
            return EcoInterceptor()
        }
        container.register(NetworkManagerProtocol.self) { resolver in
            let interceptor = resolver.resolve(RequestInterceptor.self)!
            return NetworkManager(interceptor: interceptor)
        }
    }
    
}
