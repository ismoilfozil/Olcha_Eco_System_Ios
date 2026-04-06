//
//  BaseRepository.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 25/01/23.
//

import Foundation
import Alamofire

open class BaseRepository {
    public let manager: NetworkManagerProtocol
    public init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
}

