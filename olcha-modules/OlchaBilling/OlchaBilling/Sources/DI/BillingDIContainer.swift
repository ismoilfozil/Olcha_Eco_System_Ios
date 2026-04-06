//
//  BillingDIContainer.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import Foundation
import OlchaBankCards
import OlchaUtils


public extension String {
    static let billing: String = "billing"
}
	
public class BillingDIContainer: DIResolver {
    
    public static let shared = BillingDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(assemblies: [
            CoordinatorAssembly(),
            ManagerAssembly(),
            APIAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            SceneAssembly()
        ])
        setupExtraAssemblies()
    }
    
    public func setupExtraAssemblies() {
        BalanceAssembly.shared.setupAssembly()
        BankCardAssembly.shared.setupAssembly()
        
    }
}
