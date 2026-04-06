//
//  HeaderView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 12/05/23.
//

import UIKit
public class HeaderView: BaseView {
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 20)
        label.textColor = .olchaTextBlack
        label.numberOfLines = 0
        return label
    }()
    
    public var verticalEdge: CGFloat = 16.0 {
        didSet {
            autolayout()
        }
    }

    public var horizontalEdge: CGFloat = 16.0 {
        didSet {
            autolayout()
        }
    }

    public override func setupViews() {
        addSubview(titleLabel)
    }
    
    public override func autolayout() {
        titleLabel.snp.remakeConstraints { make in
            make.right.left.equalToSuperview().inset(horizontalEdge)
            make.top.bottom.equalToSuperview().inset(verticalEdge)
        }
    }
    
    public func setup(title: String?) {
        titleLabel.text = title
    }
    
}
