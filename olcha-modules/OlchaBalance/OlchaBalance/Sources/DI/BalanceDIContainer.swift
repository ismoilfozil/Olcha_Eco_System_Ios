//
//  BalanceDIContainer.swift
//  OlchaBalance
//
//  Created by Elbek Khasanov on 06/07/23.
//

import Foundation
import OlchaUtils
import Swinject
public class BalanceDIContainer: DIResolver {
    public static let shared = BalanceDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(
            assemblies: [
                ManagerAssembly(),
                RepositoryAssembly(),
                UseCaseAssembly(),
                ViewModelAssembly(),
                ViewAssembly(),
            ]
        )
    }
}
