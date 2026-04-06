import OlchaUI
import OlchaUtils

public class EcoDIContainer: DIResolver {
    
    public static let shared: EcoDIContainer = .init()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            ManagerAssembly(),
            CommonAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly(),
        ])
    }
    
}
