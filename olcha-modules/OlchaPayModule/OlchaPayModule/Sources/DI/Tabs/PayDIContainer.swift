//
//  DIContainer.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 26/01/23.
//

import Foundation
import Swinject
import OlchaUtils
import OlchaPincode

public final class PayDIContainer: DIResolver {
    public static let shared = PayDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(
            assemblies: [
                ManagerAssembly(),
                RepositoryAssembly(),
                UseCaseAssembly(),
                SceneAssembly()
            ]
        )
        
        /*
        PincodeDIContainer.shared.container.register(PincodeViewControllerProtocol.self) { r in
            return ExamplePincodeViewController()
        }
        */
    }
    
}
