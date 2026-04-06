//
//  BaseNavigationBar.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 12/02/23.
//

import Foundation
@MainActor public protocol BaseNavigationOutput: AnyObject {
    func backButtonClicked()
}
@MainActor public protocol BaseNavigationInput: AnyObject {
    var delegate: BaseNavigationOutput? { get set }
    func setTitle(_ title: String?)
}

public extension BaseNavigationOutput {
    func backButtonClicked() {
        
    }
}

public extension BaseNavigationInput {
    func setTitle(_ title: String?) {
        
    }
}

public class EmptyNavigationBar: BaseView {}

