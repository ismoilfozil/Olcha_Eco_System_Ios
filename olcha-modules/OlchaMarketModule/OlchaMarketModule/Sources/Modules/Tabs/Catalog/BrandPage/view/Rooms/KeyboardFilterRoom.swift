//
//  KeyboardFilterRoom.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 31/08/22.
//

import UIKit
import OlchaUI
class KeyboardFilterRoom: BaseTableCell {

    private let keyboardFilter = KeyboardFilter()
    
    override func setupViews() {
        container.addSubview(keyboardFilter)
    }
    
    override func autolayout() {
        keyboardFilter.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        
    }
    
    func setup(with delegate: KeyboardFilterDelegate) {
        keyboardFilter.delegate = delegate
    }
    
}
