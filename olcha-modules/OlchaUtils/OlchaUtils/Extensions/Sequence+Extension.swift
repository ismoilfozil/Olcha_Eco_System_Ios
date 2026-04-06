//
//  Sequence+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/10/22.
//

import Foundation
import OlchaCore
public extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

public extension Array where Element: Any {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
    
    
    func isGreater(_ indexPath: IndexPath) -> Bool {
        self.count > indexPath.item
    }
    
    func isGreater(_ index: Int) -> Bool {
        self.count > index
    }
    
    func getItem(_ index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
    
    mutating func append(_ newElements: [Element]?, _ paging: Paging) {
        if paging.current == 1 {
            self.removeAll()
        }
        self.append(contentsOf: newElements ?? [])
    }
}

extension ArraySlice where Element: Any {
    var toArray: Array<Element> {
        Array(self)
    }
}
