//
//  Optional+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 05/07/22.
//

import Foundation
public extension Optional where Wrapped : Collection {
    var size: Int {
        return self?.count ?? 0
    }
    
    var isFilled: Bool {
        return !(self?.isEmpty ?? true)
    }
}

public extension Optional where Wrapped == String {
    var unwrap: String {
        return self ?? ""
    }
    
    var isNillOrEmpty: Bool {
        (self ?? "") == ""
    }
}

public extension Optional where Wrapped == Int {
    var orZero: Int {
        return self ?? 0
    }
    
    var orMinus: Int {
        return self ?? -1
    }
}

public extension Optional where Wrapped == Double {
    var orZero: Double {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Bool {
    var orFalse: Bool {
        return self ?? false
    }
    
    mutating func optionalToggle() {
        self = !(self ?? false)
    }
}
