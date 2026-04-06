//
//  BaseNavigation.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 13/02/23.
//


import UIKit
open class BaseNavigation: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configuration()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        configuration()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        self.navigationBar.isHidden = true
    }
}
