//
//  NSManagedObject+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 28/07/22.
//

import CoreData
import Foundation
public extension NSManagedObject {
    static func className() -> String {
        String(describing: self)
    }
}
