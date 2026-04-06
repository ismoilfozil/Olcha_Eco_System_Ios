//
//  CardModel.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 19/02/23.
//

import Foundation
public class CardModel {
    var numbers: String?
    var expiry: String?
    var name: String?
    var code: String?
    
    func getPan() -> String {
        (numbers ?? "").withoutSpace
    }
    
    func getExpiry() -> String {
        (expiry ?? "").digitString
    }
}
