//
//  PartnerInfoViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 19/05/23.
//

import UIKit
extension PartnerInfoViewController {
    public struct Input {
        public var partnerModel: PartnerModel? {
            didSet {
                locations = partnerModel?.addressess ?? []
                categories = partnerModel?.categories ?? []
            }
        }
        public var locations: [PartnerLocation] = []
        public var categories: [CategoryModel] = []
        public init() {}
    }
    
    public struct Output {
        public init() {}
    }
}
