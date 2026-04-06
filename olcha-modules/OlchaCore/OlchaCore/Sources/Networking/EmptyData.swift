//
//  EmptyData.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 06/05/23.
//

import Foundation
public struct EmptyData: Codable {
    public init() {}
}

public typealias ValidationErrors = [String: [String]]
