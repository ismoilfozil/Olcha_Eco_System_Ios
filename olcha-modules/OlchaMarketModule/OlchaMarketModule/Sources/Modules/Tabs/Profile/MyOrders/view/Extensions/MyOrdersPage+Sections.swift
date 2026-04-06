//
//  extension MyOrdersPage+Sections.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 05/01/24.
//

import Foundation
extension MyOrdersPage{
    public var sections: [Section] {
        return getSections()
    }
    
    enum Section {
        case empty
        case order
    }
    
    enum PageState {
        case `default`
        case loading
        case loaded
        case paginating
    }
    
    func getSections() -> [Section] {
        switch state {
        case .default:
            hideCenterProgress()
            return orders.isEmpty ? [] : [.order]
        case .loading:
            showCenterProgress()
            return orders.isEmpty ? [] : [.order]
        case .loaded:
            hideCenterProgress()
            return orders.isEmpty ? [.empty] : [.order]
        case .paginating:
            showCenterProgress()
            return orders.isEmpty ? [] : [.order]
        }
    }
}
