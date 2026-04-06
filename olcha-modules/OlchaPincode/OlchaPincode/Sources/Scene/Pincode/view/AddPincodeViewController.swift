//
//  AddPincodeViewController.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 13/02/23.
//

import UIKit
import OlchaUI
public protocol AddPincodeViewControllerProtocol: UIViewController {
    var completion: ((String) -> Void)? { get set}
    var state: PincodeType { get set}
    func inject(state: PincodeType, completion: ((String) -> Void)?)
}

open class AddPincodeViewController: BasePincodeViewController<BackNavigationBar>, AddPincodeViewControllerProtocol {
    
    public var completion: ((String) -> Void)?
    
    public var state: PincodeType = .initial
    
    public override func configureViews() {
        super.configureViews()
        set(title: "add_new_pincode".localized(.pincode))
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
            self.resetPincode()
            self.completion?(pincode)
        }
    }
    
    public func inject(state: PincodeType, completion: ((String) -> Void)?) {
        self.state = state
        self.completion = completion
    }
}
