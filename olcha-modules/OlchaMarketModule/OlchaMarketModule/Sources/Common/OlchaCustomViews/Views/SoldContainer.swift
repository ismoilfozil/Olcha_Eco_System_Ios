//
//  SoldContainer.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 19/11/22.
//

import UIKit
class SoldContainer: UIView {
    
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        container.backgroundColor = .olchaWhite.withAlphaComponent(0.5)
        container.round()
    }
}
