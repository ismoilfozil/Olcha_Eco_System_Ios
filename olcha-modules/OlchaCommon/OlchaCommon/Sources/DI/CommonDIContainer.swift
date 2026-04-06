//
//  NasiyaDIContainer.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 10/05/23.
//

import Foundation
import Swinject
import OlchaUtils
import UIKit

public class CommonDIContainer: DIResolver {
    
    public static let shared = CommonDIContainer()
    
    public override init() {
        super.init()
        
        assembler.apply(assemblies: [
            ManagerAssembly(),
            ApiAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly()
        ])
        
        registerExtraAssemblies()
    }
    
    public func registerExtraAssemblies() {
        
    }
}
