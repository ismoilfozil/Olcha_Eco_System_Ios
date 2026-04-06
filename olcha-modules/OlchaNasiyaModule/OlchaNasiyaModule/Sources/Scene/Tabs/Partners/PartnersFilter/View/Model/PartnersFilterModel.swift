//
//  PartnersFilterModel.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//

import Foundation
public protocol PartnersFilterModel {
    
    func getId() -> Int?
    func setId(id: Int?)
    
    func getTitle() -> String
    func setTitle(_ str: String?)
    
    func getIsSelected() -> Bool
    func setIsSelected(_ isSelected: Bool?)
    
}
