//
//  Copying.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/07/22.
//

import Foundation
public protocol Copying {
    init(instance: Self)
}

public extension Copying {
    func copy() -> Self {
        return Self.init(instance: self)
    }
}
