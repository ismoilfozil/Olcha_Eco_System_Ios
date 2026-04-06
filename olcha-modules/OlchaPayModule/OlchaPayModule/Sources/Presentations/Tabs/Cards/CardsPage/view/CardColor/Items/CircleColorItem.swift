//
//  CircleColorItem.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 05/02/23.
//

import UIKit
import OlchaUI
public class CircleColorItem: BaseCollectionCell {
    
    static let circleSize: CGFloat = 50
    
    private var isChosen: Bool = false {
        didSet {
            checkedIcon.isHidden = !isChosen
        }
    }
    
    private lazy var circle: UIView = {
        let view = UIView()
        view.round(CircleColorItem.circleSize / 2)
        return view
    }()
    
    private lazy var checkedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .color_check
        return imageView
    }()
    
    public override func setupViews() {
        container.addSubview(circle)
        container.addSubview(checkedIcon)
    }
    
    public override func autolayout() {
        circle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkedIcon.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    public func setup(isSelected: Bool, color: String) {
        isChosen = isSelected
        circle.backgroundColor = .hex(color)
    }
    
}
