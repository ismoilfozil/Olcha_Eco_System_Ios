//
//  PincodeModuleConfigurator.swift
//  OlchaPincode
//
//  Created by Elbek Khasanov on 19/05/23.
//

import Foundation
public final class PincodeModuleConfigurator: @unchecked Sendable {
    public static let shared = PincodeModuleConfigurator()
    /* if this is TRUE it will always show navigationbar */
    public var navigationBarEnabled = false
}
