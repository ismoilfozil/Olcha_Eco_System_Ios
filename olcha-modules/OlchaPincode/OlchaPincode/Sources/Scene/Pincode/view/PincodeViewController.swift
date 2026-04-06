//
//  PincodeViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 13/02/23.
//

import UIKit
import OlchaUI
import OlchaUtils
public protocol PincodeViewControllerProtocol: UIViewController {
    var completion: (() -> Void)? { get set }
    
    var logout: (() -> Void)? { get set }
    
    var state: PincodeType { get set }
    
    func inject(state: PincodeType, completion: (() -> Void)?, logout: (() -> Void)?)
}
open class PincodeViewController: BasePincodeViewController<BackNavigationBar>, PincodeViewControllerProtocol {
    
    public var completion: (() -> Void)?
    
    public var logout: (() -> Void)?
    
    public var state: PincodeType = .initial

    var truePincode = PincodeGlobalDefaults.session.pincode
    
    open override func configureViews() {
        super.configureViews()
        set(title: "enter_pincode".localized(.pincode))
        keyboard.withLogout = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .initial:
            navigationBar.isHidden = true
            break
        case .edit:
            navigationBar.isHidden = false
            break
        }
        
        tabBarController?.tabBar.isHidden = true
        
        if PincodeModuleConfigurator.shared.navigationBarEnabled {
            navigationBar.isHidden = false
        }
    
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        biometricChecker()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    public override func setupObservers() {
        super.setupObservers()
        
        pincodeObserver = { [weak self] pincode in
            guard let self = self else { return }
            if self.truePincode == pincode {
                self.change(state: .success) {
                    self.completion?()
                }
            } else {
                self.change(state: .fail)
            }
        }
        
        logoutObserver = { [weak self] in
            guard let self = self else { return }
            showLogout {
                PincodeGlobalDefaults.session.pincode = nil
                self.logout?()
            }
        }
    }

    public func inject(state: PincodeType, completion: (() -> Void)?, logout: (() -> Void)?) {
        self.state = state
        self.completion = completion
        self.logout = logout
    }
    
    private func biometricChecker() {
        guard PincodeGlobalDefaults.settings.biometricEnabled ?? false else { return }
        BiometricManager.shared.checkBiometric { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.change(state: .success) {
                    self.completion?()
                }
            }
        }
    }
}
