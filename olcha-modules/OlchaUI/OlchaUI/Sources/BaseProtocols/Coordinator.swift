//
//  Coordinator.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 27/04/23.
//

import UIKit
public protocol Coordinator: AnyObject, Nameable {
    var navigationController: UINavigationController { get }
    func start()
    func dismissPresentedViewController()
}

public extension Coordinator {
    func dismissPresentedViewController() {
        if navigationController.presentedViewController is ModalPageType {
            navigationController.dismiss()
        }
    }
}
