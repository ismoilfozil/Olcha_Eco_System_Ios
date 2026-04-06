//
//  NasiyaDIContainer.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
import OlchaUtils
import OlchaVerification
import UIKit
import OlchaAuth
extension String {
    static let nasiya = "nasiya"
}
public class NasiyaDIContainer: DIResolver {
    
    public static let shared = NasiyaDIContainer()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            ManagerAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly()
        ])
        setupExtraAssemblies()
        
    }
    
    public func setupExtraAssemblies() {
        VerificationAssembly.shared.setupAssembly()
    }
}
