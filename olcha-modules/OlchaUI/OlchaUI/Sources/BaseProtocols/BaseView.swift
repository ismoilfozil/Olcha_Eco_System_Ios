//
//  BaseView.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 02/02/23.
//

import UIKit
open class BaseView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseSetup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        baseSetup()
    }
    
    
    private func baseSetup() {
        setupViews()
        autolayout()
        configureViews()
    }
    open func setupViews() {}
    open func autolayout() {}
    open func configureViews() {}
    open func languageUpdated() {}
}

