//
//  LetterBrandModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import Foundation
class LetterBrandModel {
    let letter: String
    var brands: [Manufacturer] = []
    
    init(letter: String) {
        self.letter = letter
    }
}
