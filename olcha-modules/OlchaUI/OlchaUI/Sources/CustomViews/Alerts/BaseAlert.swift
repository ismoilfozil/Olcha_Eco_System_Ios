//
//  BaseAlert.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/10/22.
//


import UIKit
import Combine
import OlchaUtils
public enum AlertType {
    case error(text: String?)
    case success(text: String?)
    case orderSuccess(type: OrderSuccessAlertView.SuccessType,
                      homeObserver: (() -> Void),
                      actionObserver: (() -> Void) )
    
    case submit(text: String?)
    case adult
    case warning(text: String?)
    case version(state: VersionState)
    case submitConfiguration(title: String?,
                             content: String?,
                             axis: NSLayoutConstraint.Axis,
                             yesButtonText: String)
    case refreshAuth
    case `default`(title: String?, content: String?)
}


@MainActor public protocol BaseAlertDelegate: AnyObject {
    func dismiss()
    func okClicked(dismiss: Bool)
}

public class BaseAlert: UIViewController {
    
    public var dismissClicked: (() -> Void)?
    
    public var agreeClicked: (() -> Void)?
    
    public init(type: AlertType) {
        super.init(nibName: nil, bundle: nil)
        
        switch type {
            case .error(let text):
            let alert = ErrorAlertView()
            alert.set(text: text)
            alert.delegate = self
            view = alert
            break
        case .submit(let text):
            let alert = SubmitAlertView()
            alert.set(text: text)
            alert.delegate = self
            view = alert
            break
        case .orderSuccess(let type, let homeObserver, let actionObserver):
            let alert = OrderSuccessAlertView()
            alert.currentType = type
            alert.delegate = self
            alert.homeClickObserver = homeObserver
            alert.doneClickObserver = actionObserver
            view = alert
            break
        case .success(let text):
            let alert = SuccessAlertView()
            alert.set(text: text)
            alert.delegate = self
            view = alert
            break
        case .adult:
            let alert = AdultAlertView()
            alert.delegate = self
            view = alert
            break
        case .warning(let text):
            let alert = SuccessAlertView()
            alert.delegate = self
            alert.set(text: text, successTitle: "message".localized())
            view = alert
            break
        case .version(let state):
            let alert = VersionAlertView()
            alert.delegate = self
            alert.set(state: state)
            view = alert
        case .submitConfiguration(let title,
                                  let content,
                                  let axis,
                                  let yesButtonText):
            
            let alert = SubmitAlertView()
            alert.delegate = self
            alert.configure(title: title,
                            content: content,
                            yesButtonText: yesButtonText,
                            axis: axis)
            view = alert
        case .refreshAuth:
            let alert = RefreshAuthAlertView()
            alert.delegate = self
            view = alert
        case .default(let title, let content):
            let alert = DefaultAlert()
            alert.delegate = self
            alert.setup(title: title, content: content)
            view = alert
        }
        baseSetup()
    }
    
    private func baseSetup() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension BaseAlert: BaseAlertDelegate {
    public func okClicked(dismiss: Bool) {
        
        if dismiss {
            self.dismiss(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self.agreeClicked?()
            })
        } else {
            agreeClicked?()
        }
    }
    
    public func dismiss() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.dismissClicked?()
        })
    }
}

