//
//  AuthDIContainer.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Foundation
import OlchaUtils
public final class AuthDIContainer: DIResolver, @unchecked Sendable {
    
    public static let shared = AuthDIContainer()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            ManagerAssembly(),
            ApiAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly()
        ])
        
    }
}
