//
//  OlchaVerificationDIContainer.swift
//  OlchaVerification
//
//  Created by Elbek Khasanov on 20/05/23.
//

import Foundation
import Swinject
import OlchaUtils
public class OlchaVerificationDIContainer: DIResolver {
    public static let shared = OlchaVerificationDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(
            assemblies: [
                ApiAssembly(),
                ManagerAssembly(),
                RepositoryAssembly(),
                UseCaseAssembly(),
                CoordinatorAssembly(),
                ViewModelAssembly(),
                ViewAssembly()
            ]
        )
    }
    
    public func authCreditViewModel() -> AuthCreditViewModel {
        OlchaVerificationDIContainer.shared.resolve(name: .shared)
    }
}
