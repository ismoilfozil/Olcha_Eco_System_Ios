//
//  Skeleton.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 03/11/22.
//

import Foundation
import OlchaCore
public class Skeleton {
    public var isEnabled: Bool = true
    
    public var isAnimating: Bool
    
    public var count: Int
    
    public init(count: Int = 4, isAnimating: Bool = true) {
        self.count = count
        self.isAnimating = isAnimating
    }
 
    public func getCount(_ listCount: Int) -> Int {
        isAnimating ? (listCount + count) : listCount
    }
    
    public func getPagingCount(_ listCount: Int) -> Int {
        isAnimating ? 1 : listCount
    }
    
    public func initialSkeleton(isAnimating: Bool, _ page: Int) {
        if page > 1 {
            self.isAnimating = false
        } else {
            self.isAnimating = isAnimating
        }
    }
    
    public func initialSkeleton(isAnimating: Bool, _ paging: Paging) {
        if paging.current > 1 {
            self.isAnimating = false
        } else {
            self.isAnimating = isAnimating
        }
    }
}
