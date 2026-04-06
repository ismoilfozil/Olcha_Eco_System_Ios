//
//  PartnerFiler.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
import OlchaCore
import OlchaUtils
import Combine
public class PartnerFilter {
    
    public var partners = PagingData<PartnerModel>()
    
    public var selectedRegion: PartnersFilterModel? {
        didSet {
            if selectedRegion?.getId() != oldValue?.getId() {
                partnersLoader.send(true)
            }
        }
    }
    
    public var selectedCategory: PartnersFilterModel?  {
        didSet {
            if selectedCategory?.getId() != oldValue?.getId() {
                partnersLoader.send(true)
            }
        }
    }
    
    public var searchText: String?  {
        didSet {
            if searchText != oldValue {
                partnersLoader.send(true)
            }
        }
    }
    
    public var regions: [PartnersFilterModel] = [
        
    ]
    
    public var categories: [PartnersFilterModel] = [
    
    ]
    
    public let partnersLoader = PassthroughSubject<Bool, Never>()
    
    public init(paging: Paging = .init()) {}
    
    public func resetAllFilters() {
        self.partners.reset()
        self.selectedRegion = nil
        self.selectedCategory = nil
        self.searchText = nil
    }
    
    public func reset() {
        partners.reset()
    }
    
    public func resetFilters() {
        resetAllFilters()
        regions.removeAll()
        categories.removeAll()
        partners.reset()
        selectedRegion = nil
        selectedCategory = nil
    }
}
