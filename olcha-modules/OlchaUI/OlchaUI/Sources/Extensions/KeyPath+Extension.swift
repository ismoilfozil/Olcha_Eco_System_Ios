//
//  KeyPath+Extension.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 10/08/23.
//

import Foundation
extension KeyPath {
    public var propertyName: String {
        return "\(self)".split(separator: ".").last?.description ?? ""
    }
}


