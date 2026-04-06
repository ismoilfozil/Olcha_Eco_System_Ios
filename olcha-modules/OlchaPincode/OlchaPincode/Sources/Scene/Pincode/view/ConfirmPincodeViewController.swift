//
//  ConfirmPincodeViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 13/02/23.
//

import UIKit
import OlchaUI
public protocol ConfirmPincodeViewControllerProtocol: UIViewController {
    var completion: (() -> Void)? { get set }
    
    var lastPincode: String? { get set }
    
    var state: PincodeType { get set }
    
    func inject(lastPincode: String?, state: PincodeType, completion: (() -> Void)?)
}

open class ConfirmPincodeViewController: BasePincodeViewController<BackNavigationBar>, ConfirmPincodeViewControllerProtocol {
    
    public var completion: (() -> Void)?
    
    public var lastPincode: String?
    
    public var state: PincodeType = .initial
    
    public override func configureViews() {
        super.configureViews()
        set(title: "confirm_new_pincode".localized(.pincode))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .initial:
            navigationBar.isHidden = false
            break
        case .edit:
            navigationBar.isHidden = false
            break
        }
        
        tabBarController?.tabBar.isHidden = true
    #warning("MODULE ERROR")
        if PincodeModuleConfigurator.shared.navigationBarEnabled {
            navigationBar.isHidden = false
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    public override func setupObservers() {
        super.setupObservers()
        pincodeObserver = { [weak self] pincode in
            guard let self = self else { return }
            
            if self.lastPincode == pincode {
                self.change(state: .success) {
                    self.completion?()
                }
            } else {
                self.change(state: .fail)
            }
            
        }
    }
    
    public func inject(lastPincode: String?,
                       state: PincodeType,
                       completion: (() -> Void)?
    ) {
        self.lastPincode = lastPincode
        self.state = state
        self.completion = completion
    }
}
