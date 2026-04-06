//
//  BasePincodeViewController.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 13/02/23.
//
import OlchaUI
import UIKit
open class BasePincodeViewController<Navigation: UIView>: BaseViewController<Navigation> {
    
    public enum PincodeState {
        case success
        case fail
    }
    
    public let titleLabel = UILabel()
    public let header = PincodeDotsView()
    public let keyboard = KeyboardView()
    
    public var currentPincode: String = ""
    
    private  var maxCount: Int {
        header.count
    }
    
    public var withLogout: Bool = false {
        didSet {
            keyboard.withLogout = withLogout
        }
    }
    
    open var pincodeObserver: ((String) -> Void)?
    
    open var logoutObserver: (() -> Void)?
    
    open override func setupViews() {
        container.addSubview(titleLabel)
        container.addSubview(header)
        container.addSubview(keyboard)
    }
    
    open override func autolayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.top.equalToSuperview()
        }
        
        header.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-24)
        }
        
        keyboard.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
    }
    
    open override func configureViews() {
        
        titleLabel.style(.semibold, 18)
        titleLabel.textColor = .olchaTextBlack
        
    }
    
    open override func setupObservers() {
        keyboard.clickObserver = { [weak self] item in
            guard let self = self else { return }
            
            switch item {
            case .clear:
                self.clearLogic()
                break
            case .logout:
                self.logout()
                break
            default:
                self.numberLogic(item.rawValue)
                break
            }
        }
    }
    
    private func clearLogic() {
        guard currentPincode.count > 0 else { return }
        currentPincode.removeLast()
        pincodeActions()
    }
    
    private func numberLogic(_ number: Int) {
        guard currentPincode.count < maxCount else { return }
        currentPincode = currentPincode + number.string
        pincodeActions()
    }
    
    private func logout() {
        logoutObserver?()
    }
    
    private func pincodeActions() {
        
        header.changeState(step: currentPincode.count)
        if currentPincode.count == maxCount {
            pincodeObserver?(currentPincode)
        }
    }
    
    public func change(state: PincodeState, completed: (() -> Void)? = nil) {
        switch state {
        case .success:
            header.successState()
            break
        case .fail:
            header.errorState()
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.resetPincode()
            completed?()
        }
    }
    
    public func set(title: String) {
        titleLabel.text = title
    }
    
    public func ignoreNavigationBar() {
        
        container.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }

    public func resetPincode() {
        currentPincode = ""
        header.defaultState()
    }
}
