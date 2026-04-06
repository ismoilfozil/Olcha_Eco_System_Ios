//
//  UIView+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 24/06/22.
//

import UIKit
import Foundation
import SnapKit
class DiagonalLine: UIView {

    private let line: UIView

    init() {
        
        line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .black.withAlphaComponent(0.8)

        super.init(frame: .zero)

        clipsToBounds = true

        addSubview(line)

        line.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(400)
            make.centerX.centerY.equalToSuperview()
        }
        
        line.transform = .init(rotationAngle: 150.0 * .pi / 180.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
