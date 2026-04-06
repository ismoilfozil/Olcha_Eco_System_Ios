import Foundation
import OlchaUtils

public class SayohatDIContainer: DIResolver {
    
    public static let shared = SayohatDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(assemblies: [
            SceneAssembly()
        ])
    }
    
}
