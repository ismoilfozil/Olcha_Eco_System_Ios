//
//  Label.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 17/10/22.
//

import UIKit
public class Label: BaseView {
    
    public let settings = UILabel()
    
    public var text: String = "" {
        didSet {
            settings.text = text
            updateLayout()
        }
    }
    
    public var horizontalInset: CGFloat = 4 {
        didSet {
            updateLayout()
        }
    }
    
    public var verticalInset: CGFloat = 4 {
        didSet {
            updateLayout()
        }
    }
   
    override public func setupViews() {
        addSubview(settings)
    }
    
    override public func autolayout() {
        settings.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func updateLayout() {
        settings.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset((text == "") ? 0 : horizontalInset)
            make.top.bottom.equalToSuperview().inset((text == "") ? 0 : verticalInset)
        }
    }
}
