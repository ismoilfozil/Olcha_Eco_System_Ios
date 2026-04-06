//
//  CashbackDIContainer.swift
//  OlchaBilling
//
//  Created by Elbek Khasanov on 20/06/23.
//

import Foundation
import OlchaUtils


public extension String {
    static let billing: String = "billing"
}
	
public class CashbackDIContainer: DIResolver {
    
    nonisolated(unsafe) public static let shared = CashbackDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(assemblies: [
            SceneAssembly()
        ])
    }
    
}
