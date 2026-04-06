//
//  InstallmentSortModal+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 17/06/23.
//

import UIKit
extension InstallmentSortModal {
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        weak var filters: InstallmentFilter? {
            didSet {
                copiedFilters = filters?.copy() ?? .init()
            }
        }
        var copiedFilters = InstallmentFilter()
        
        public init() {}
        
        public func acceptCopy() {
            filters?.allStatuses = copiedFilters.allStatuses
            filters?.installments = copiedFilters.installments
            filters?.statusObserver = copiedFilters.statusObserver
            filters?.status = copiedFilters.status
        }
    }
}
