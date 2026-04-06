//
//  RefreshAuthProtocol.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 15/01/24.
//

import Foundation
import Combine

public typealias RefreshCompletion = (() -> Void)

public class RefreshAuthObserver: @unchecked Sendable {
    
    public static let shared = RefreshAuthObserver()
    
    public let refreshExpireObserver = PassthroughSubject<RefreshCompletion, Never>()
    
}

