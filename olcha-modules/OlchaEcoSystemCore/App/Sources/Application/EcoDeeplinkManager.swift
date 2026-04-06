//
//  EcoDeeplinkManager.swift
//  OlchaEcoSystemCore
//
//  Created by Elbek Khasanov on 29/11/23.
//  Copyright © 2023 Olcha. All rights reserved.
//

import Foundation
import OlchaUtils

public class EcoDeeplinkManager {
    
    public static let shared = EcoDeeplinkManager()
    
    public init() {}
    
    public func deeplinkRoute(_ urlString: String?) -> OlchaModule {
        guard let urlString else { return .ecosystem }
        return getApp(from: urlString)
    }
    
    private func getApp(from urlString: String) -> OlchaModule {
        switch urlString {
        case _ where urlString.contains("olcha.uz"):
            return .olcha
        case _ where urlString.contains("olchanasiya.uz"):
            return .nasiya
        case _ where urlString.contains("olchainvest.uz"):
            return .invest
        case _ where urlString.contains("olchapay.uz"):
            return .pay
        default:
            return .ecosystem
        }
    }
}
