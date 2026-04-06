//
//  BaseViewController+Alert.swift
//  OlchaUI
//
//  Created by Elbek Khasanov on 06/02/23.
//

import UIKit
import OlchaUtils

extension UIViewController {
    
    public func showDefaultAlert(title: String?, content: String?, completion: (() -> Void)? = nil) {
        let alert = BaseAlert(type: .default(title: title, content: content))
        alert.dismissClicked = completion
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showVersion(state: VersionState, observer: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .version(state: state))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showError(text: String?) {
        let alert = BaseAlert(type: .error(text: text))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showWarning(text: String?) {
        let alert = BaseAlert(type: .warning(text: text))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showSuccess(text: String?, dismissClicked: (() -> Void)? = nil) {
        let alert = BaseAlert(type: .success(text: text))
        alert.dismissClicked = dismissClicked
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showDeleteCard(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(
            type: .submitConfiguration(title: "delete_card".localized(), content: "really_delete_card".localized(), axis: .horizontal, yesButtonText: "delete".localized())
        )
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showLogout(observer: @escaping (() -> Void)) {
        print("try logggout")
        let alert = BaseAlert(
            type: .submitConfiguration(title: "logout".localized(), content: "really_logout".localized(), axis: .horizontal, yesButtonText: "yes".localized())
        )
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showRetryTransaction(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(
            type: .submitConfiguration(title: "retry".localized(), content: "really_retry".localized(), axis: .horizontal, yesButtonText: "yes".localized())
        )
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showCameraError() {
        let alert = BaseAlert(type: .submit(text: "agree_camera_usage".localized()))
        alert.agreeClicked = { [weak self] in
            guard let self = self else { return }
            self.openURL(UIApplication.openSettingsURLString)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showBiometricError(cancelObserver: @escaping (() -> Void), okObserver: @escaping (() -> Void)) {
        let alert = BaseAlert(
            type: .submit(
                text: "agree_\(BiometricManager.shared.biometricType() == .face ? "face" : "touch")_id_usage".localized()))
        alert.agreeClicked = okObserver
        alert.dismissClicked = cancelObserver
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showLocationAlert(cancelObserver: @escaping (() -> Void), okObserver: @escaping (() -> Void)) {
        let alert = BaseAlert(
            type: .submit(text: "not_accessed_location".localized()))
        alert.agreeClicked = okObserver
        alert.dismissClicked = cancelObserver
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showShareCheck(data: Data?) {
        let dataShare: [Any] = [ data ]
        
        let activityViewController = UIActivityViewController(activityItems: dataShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    public func showShare(text: String?) {
        let dataShare: [Any] = [ text ]
        
        let activityViewController = UIActivityViewController(activityItems: dataShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    public func showBiometricPermissionAlert() {
        showBiometricError {} okObserver: { [weak self] in
            guard let self = self else { return }
            self.openURL(UIApplication.openSettingsURLString)
        }
    }
    
    public func showLocationPermissionAlert() {
        showLocationAlert(cancelObserver: {}, okObserver: { [weak self] in
            guard let self else { return }
            openURL(UIApplication.openSettingsURLString)
        })
    }
    
    public func showNasiyaAlertView(message: String?, type: NasiyaAlertType, completion: (() -> Void)? = nil) {
        let vc = NasiyaAlertView()
        vc.alertType = type
        vc.message = message
        vc.modalPresentationStyle = .overFullScreen
        vc.alertButtonObserver = completion
        self.present(vc, animated: false)
    }
    
    public func showNetworkStatusAlertView(completion: (() -> Void)? = nil) {
        let vc = NetworkStatusAlertView()
        vc.modalPresentationStyle = .overFullScreen
        vc.alertButtonObserver = completion
        self.present(vc, animated: true)
    }
}

public extension UIViewController {
    func refreshAuthAlert(completion: (() -> Void)? = nil) {
        let vc = BaseAlert(type: .refreshAuth)
        vc.agreeClicked = completion
        self.present(vc, animated: true)
    }
}
