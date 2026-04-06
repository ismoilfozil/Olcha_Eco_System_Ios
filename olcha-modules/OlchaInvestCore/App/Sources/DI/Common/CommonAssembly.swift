//
//  CommonAssembly.swift
//  OlchaInvestCore
//
//  Created by Akhrorkhuja on 27/05/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Swinject
import OlchaCore
import Alamofire

public final class CommonAssembly: Assembly {
 
    public func assemble(container: Container) {
        container.register(RequestInterceptor.self) { _ in
            return InvestInterceptor()
        }
        container.register(NetworkManagerProtocol.self) { resolver in
            let interceptor = resolver.resolve(RequestInterceptor.self)!
            return NetworkManager(interceptor: interceptor)
        }
    }
    
}
