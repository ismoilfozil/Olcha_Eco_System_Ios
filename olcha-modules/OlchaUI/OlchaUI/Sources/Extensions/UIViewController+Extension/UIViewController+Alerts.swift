//
//  UIViewController+Alerts.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 13/10/22.
//


import UIKit
import Toaster
@preconcurrency import GSMessages

extension UIViewController {

    
    public func presentDatePicker(datePicker: UDatePicker?,
                                  minimumDate: Date? = nil,
                                  maximumDate: Date? = nil,
                                  dateString: String? = nil,
                                  completion: @escaping ((String) -> Void)) -> UDatePicker? {
        var _datePicker: UDatePicker? = datePicker
        if _datePicker == nil {
            _datePicker = UDatePicker(frame: view.frame, willDisappear: { date in
                if let date = date {
                    completion(date.string)
                }
            })
            
        }
        
        
        _datePicker?.configure(dateString: dateString)
        _datePicker?.picker.datePicker.maximumDate = maximumDate
        _datePicker?.picker.datePicker.minimumDate = minimumDate
        _datePicker?.present(self)
        
        return _datePicker
    }
    
    public func showDeleteAccount(observer: @escaping (() -> Void)) {
        let alert = BaseAlert(type: .submit(text: "really_delete_account".localized()))
        alert.agreeClicked = observer
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIViewController {
    public func showToast(text: String?) {
        guard let text else { return }
//        ToastCenter.default.cancelAll()
//        Toast(text: text, delay: 0, duration: 1)
//            .show()
        
        GSMessage.font = .style(.medium, 12)
        GSMessage.infoBackgroundColor = .hex("#646464")
        GSMessage.showMessageAddedTo(text: text,
                                     type: .info,
                                     options: [
                                        .animations([.fade]),
                                        .autoHide(true),
                                        .cornerRadius(20),
                                        .position(.top),
                                        .textAlignment(.center),
                                        .textColor(.olchaWhite),
                                        .autoHideDelay(3),
                                        .isInsideSafeAreaInsets(true),
                                        .margin(.init(top: 32, left: 32, bottom: 0, right: 32))
                                     ],
                                     inView: view,
                                     inViewController: nil)
        

    }
}
