//
//  PartnersFilterViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
extension PartnersFilterViewController {
    public struct Input {
        public var models: [any PartnersFilterModel] = []
        
        public init() {}
    }
}
