//
//  Int+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/07/22.
//


import UIKit
public extension Int {
    static let authError = 401

    static func page(offset: CGPoint, collection: UIScrollView) -> Int? {
        let width = collection.frame.width
        let result = (offset.x / width).rounded(.toNearestOrAwayFromZero)
        
        if result.isInfinite || result.isNaN {
            return nil
        } else {
            return Int(result)
        }
    }
    
    var cgfloat: CGFloat {
        CGFloat(self)
    }
    
    var float: Float {
        Float(self)
    }
    
    var string: String {
        String(self)
    }
    
    var double: Double {
        Double(self)
    }
    var int16: Int16 {
        Int16(self)
    }
    
    var int64: Int64 {
        Int64(self)
    }
        
}
public extension Float {
    var string: String {
        String(self)
    }
}

public extension Double {
    var string: String {
        String(self)
    }
}

public extension Int16 {
    var int: Int {
        Int(self)
    }
}

public extension Int64 {
    var int: Int {
        Int(self)
    }
}
