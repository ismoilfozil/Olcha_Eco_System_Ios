//
//  OlchaBankCardsDIContainer.swift
//  OlchaBankCards
//
//  Created by Elbek Khasanov on 22/05/23.
//

import Foundation
import Swinject
import OlchaUtils
public class BankCardsDIContainer: DIResolver {
    public static let shared = BankCardsDIContainer()
    
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
