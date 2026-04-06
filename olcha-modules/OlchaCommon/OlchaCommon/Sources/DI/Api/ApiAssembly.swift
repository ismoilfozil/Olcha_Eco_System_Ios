//
//  ManagerAssembly.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Foundation
import Swinject
import Alamofire
import OlchaCore
import OlchaAuth
import OlchaUtils
final class ApiAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CommonAPI.self) { (r, organization: Organization) in
            return CommonAPI(organization: organization)
        }
        
        container.register(LoyaltyAPIProtocol.self) { _ in
            return LoyaltyAPI()
        }
    }
}
