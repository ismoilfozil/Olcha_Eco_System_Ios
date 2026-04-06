//
//  PincodeCoordinator.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 13/02/23.
//

import UIKit
import OlchaUI
public enum PincodeType {
    case initial
    case edit
}

public protocol PincodeCoordinatorProtocol: Coordinator {
    var navigationController: UINavigationController { get set }
    var completion: (() -> Void)? { get set }
    var logout: (() -> Void)? { get set }
    
    func startPincodeFlow()
    func startAddPincodeFlow()
    func startEditPincodeFlow()
}

public class PincodeCoordinator: PincodeCoordinatorProtocol {
    
    public var completion: (() -> Void)?
    
    public var logout: (() -> Void)?
    
    private var state: PincodeType
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController = BaseNavigation(),
                state: PincodeType
    ) {
        self.state = state
        self.navigationController = navigationController
    }
    
    public func start() {}
    
    public func startPincodeFlow() {
        pushPincode { [weak self] in
            guard let self = self else { return }
            self.navigationController.dismiss()
            self.completion?()
        } logout: { [weak self] in
            guard let self = self else { return }
            self.logout?()
        }
    }
    
    public func startAddPincodeFlow() {
        pushAddPincode { [weak self] pincode in
            guard let self = self else { return }
            self.pushConfirmPincode(lastPincode: pincode) {
                PincodeGlobalDefaults.session.pincode = pincode
                self.navigationController.dismiss()
                self.completion?()
            }
        }
    }
    
    public func startEditPincodeFlow() {
        pushPincode { [weak self] in
            guard let self = self else { return }
            self.pushAddPincode { pincode in
                self.pushConfirmPincode(lastPincode: pincode) {
                    PincodeGlobalDefaults.session.pincode = pincode
                    self.navigationController.dismiss()
                    self.completion?()
                }
            }
        } logout:  { [weak self] in
            guard let self = self else { return }
            self.logout?()
        }
    }
    
}
//Pincode Flow
extension PincodeCoordinator {
    private func pushPincode(completion: @escaping() -> Void, logout: @escaping() -> Void) {
        let vc: PincodeViewControllerProtocol = PincodeDIContainer.shared.resolve()
        
        vc.inject(state: state) {
            completion()
        } logout: {
            logout()
        }

        
        vc.modalPresentationStyle = .fullScreen
        
        navigationController.push(vc)
    }
    
    private func pushAddPincode(completion: @escaping(String) -> Void) {
        let vc: AddPincodeViewControllerProtocol = PincodeDIContainer.shared.resolve()
        
        vc.inject(state: state) { pincode in
            completion(pincode)
        }
        
        vc.modalPresentationStyle = .fullScreen
        
        navigationController.push(vc)
    }
    
    private func pushConfirmPincode(lastPincode: String, completion: @escaping() -> Void) {
        let vc: ConfirmPincodeViewControllerProtocol = PincodeDIContainer.shared.resolve()

        vc.inject(lastPincode: lastPincode, state: state) {
            completion()
        }
        
        navigationController.push(vc)
    }
}
