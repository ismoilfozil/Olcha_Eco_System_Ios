//
//  PincodeDIContainer.swift
//  OlchaPincode
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
import OlchaUtils
public final class PincodeDIContainer: DIResolver, @unchecked Sendable {
    public static let shared = PincodeDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(
            assemblies: [
                ScenePincodeAssembly()
            ]
        )
    }
    
}


