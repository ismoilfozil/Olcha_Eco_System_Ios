//
//  ScenePincodeAssembly.swift
//  OlchaPincode
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
import Swinject

open class ScenePincodeAssembly: Assembly {
    public func assemble(container: Container) {    
        container.register(AddPincodeViewControllerProtocol.self) { r in
            return AddPincodeViewController()
        }
        
        container.register(PincodeViewControllerProtocol.self) { r in
            return PincodeViewController()
        }
        
        container.register(ConfirmPincodeViewControllerProtocol.self) { r in
            return ConfirmPincodeViewController()
        }
    }
}
