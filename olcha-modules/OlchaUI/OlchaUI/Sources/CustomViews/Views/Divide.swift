//
//  Separator.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 27/07/22.
//


import UIKit
import SnapKit
public class Divide: UIView {
    
    private let separator = UIView()
    
    public var color: UIColor? = .olchaLightNeutralGray {
        didSet {
            separator.backgroundColor = color
        }
    }
    
    public var height: CGFloat = 1 {
        didSet {
            separator.snp.updateConstraints { $0.height.equalTo(height) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        separator.backgroundColor = .olchaLightNeutralGray
        separator.round(0.5)
    }
}

public class HorizontalDivide: UIView {
    
    private let separator = UIView()
    
    public var color: UIColor? = .olchaLightNeutralGray {
        didSet {
            separator.backgroundColor = color
        }
    }
    
    public var width: CGFloat = 1 {
        didSet {
            separator.snp.updateConstraints { $0.width.equalTo(width) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        separator.backgroundColor = .olchaLightNeutralGray
        separator.round(0.5)
    }
}
