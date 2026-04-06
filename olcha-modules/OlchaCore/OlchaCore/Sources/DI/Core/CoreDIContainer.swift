//
//  CoreDIContainer.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 21/08/23.
//

import Foundation

import Alamofire

public class CoreDIContainer: @unchecked Sendable {
    
    public static let shared = CoreDIContainer()
    
    public func networkManager(interceptor: RequestInterceptor, name: String) -> NetworkManagerProtocol {
        NetworkManager(interceptor: interceptor)
    }
}
