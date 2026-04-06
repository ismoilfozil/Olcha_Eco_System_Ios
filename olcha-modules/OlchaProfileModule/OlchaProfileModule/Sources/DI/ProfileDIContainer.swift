//
//  ProfileDIContainer.swift
//  ProfileDIContainer
//
//  Created by Elbek Khasanov on 20/09/23.
//

import Foundation
import OlchaUtils
public class ProfileDIContainer: DIResolver {
    public static let shared = ProfileDIContainer()
    
    public override init() {
        super.init()
        assembler.apply(
            assemblies: [
                SceneAssembly()
            ]
        )
    }
    
}


