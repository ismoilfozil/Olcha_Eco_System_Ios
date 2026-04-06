//
//  RequestId.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 03/05/23.
//

import Foundation
public struct RequestId : Codable {
    let id: Int
    
    
    public init(id: Int) {
        self.id = id
    }
}
