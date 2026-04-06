//
//  BaseViewController+Handler.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 23/01/23.
//

import UIKit
import Combine
import OlchaCore
import ProgressHUD
@MainActor fileprivate var olchaIndicator: OlchaIndicator?

@MainActor fileprivate var bag = Set<AnyCancellable>()

extension UIViewController {
    @objc open var validatedFields: [TField] {
        return []
    }
}

public extension UIViewController {
    
    func handle<Value: Any, ErrorType: Any>(
        _ loadingState: Published<LoadingState<Value, ErrorType>>.Publisher,
        showLoader: Bool = false,
        withError: Bool = true,
        success: ((Value?) -> Void)? = nil,
        failure: ((ErrorType?) -> Void)? = nil,
        loading: ((Bool) -> Void)? = nil
    ) {
        
        loadingState
            .sink { [weak self] state in
                guard let self = self else { return }
                self.handleState(state: state,
                                 showLoader: showLoader,
                                 withError: withError,
                                 loading: loading,
                                 success: success,
                                 failure: failure)
            }
            .store(in: &bag)
        
    }
    
    func handleState<Value: Any, ErrorType: Any>(
        state: LoadingState<Value, ErrorType>,
        showLoader: Bool,
        withError: Bool,
        loading: ((Bool) -> Void)?,
        success: ((Value?) -> Void)?,
        failure: ((ErrorType?) -> Void)? = nil) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch state {
                case .standart:
                    loading?(false)
                    self.hideLoader()
                    break
                case .loading:
                    showLoader ? self.showLoader() : nil
                    loading?(true)
                    break
                case let .success(value):
                    loading?(false)
                    showLoader ? self.hideLoader() : nil
                    success?(value)
                    break
                case let .failure(error):
                    loading?(false)
                    showLoader ? self.hideLoader() : nil
                    failure?(error)
                    if withError {
                        if let baseError = error as? BaseErrorType {
                            validateFields(fields: validatedFields, error: baseError)
                        }
                    }
                    break
                }
            }
        }
    
    func showLoader() {
        var indicator = (self as? IndicatorProtocol)
        indicator?.count += 1

        olchaIndicator?.removeFromSuperview()
        olchaIndicator = nil
        
        let activityIndicator = OlchaIndicator()
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        olchaIndicator = activityIndicator
    }
    
    func hideLoader() {
        var indicator = (self as? IndicatorProtocol)
        indicator?.count -= 1
        if (indicator?.count ?? 0) <= 0 {
            olchaIndicator?.removeFromSuperview()
            olchaIndicator = nil
        }
    }
    
    func showPostProgress() {
        
        ProgressHUD.animationType = .lineSpinFade
        ProgressHUD.colorAnimation = .olchaAccentColor
        ProgressHUD.show(interaction: false)
        
    }
    
    func hidePostProgress() {
        
        ProgressHUD.dismiss()
    }
}
