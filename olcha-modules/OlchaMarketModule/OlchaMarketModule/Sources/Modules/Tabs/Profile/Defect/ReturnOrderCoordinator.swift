//
//  ReturnOrderCoordinator.swift
//  OlchaMarketModule
//
//  Created by Elbek Khasanov on 18/10/23.
//

import UIKit
import OlchaUI
import Combine

public protocol ReturnOrderCoordinatorProtocol: Coordinator {
    func start(animated: Bool)
    func pushReturnOrderProducts(order: Order?)
    func pushReturnOrderProduct(order: Order?, product: ProductModel?)
    func presentMediaType(mediaType: MediaPicker.MediaType, imageObserver: PassthroughSubject<UIImage?, Never>)
    func finishReturning()
}

class ReturnOrderCoordinator: ReturnOrderCoordinatorProtocol {
    private var picker: MediaPicker?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc: ReturnOrderSearchViewController = .init()
        vc.coordinator = self
        navigationController.push(vc)
    }
    
    func start(animated: Bool) {
        let vc: ReturnOrderSearchViewController = .init()
        vc.coordinator = self
        navigationController.push(vc, animated: animated)
    }
    
    func pushReturnOrderProducts(order: Order?) {
        let vc: ReturnOrderProductsViewController = .init()
        vc.coordinator = self
        vc.input.order = order
        vc.setupData()
        navigationController.push(vc)
    }
    
    func pushReturnOrderProduct(order: Order?, product: ProductModel?) {
        let vc: ReturnOrderReasonViewController = .init()
        vc.coordinator = self
        vc.input.order = order
        vc.input.product = product
        vc.setupData()
        navigationController.push(vc)
    }
    
    public func presentMediaType(mediaType: MediaPicker.MediaType,
                                 imageObserver: PassthroughSubject<UIImage?, Never>) {
        
        let vc = MediaTypeModalPage()
        
        vc.mediaClicked = { [weak self] type in
            guard let self = self else { return }
            self.mediaPicker(type: mediaType,
                             sourceType: type,
                             imageObserver: imageObserver)
        }
        
        navigationController.presentModally(vc)
    }
    
    private func mediaPicker(type: MediaPicker.MediaType,
                             sourceType: UIImagePickerController.SourceType,
                             imageObserver: PassthroughSubject<UIImage?, Never>?) {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
        picker = MediaPicker()
        picker?.mediaType = type
        picker?.selectedImageObserver = imageObserver
        picker?.present(navigationController: navigationController, sourceType: sourceType)
    }
    
    public func finishReturning() {
        navigationController.popLastViewController(to: ReturnOrderSearchViewController.self)
    }
}
