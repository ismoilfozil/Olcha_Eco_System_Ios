//
//  BaseViewController+Toaster.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 15/06/23.
//

import UIKit
import OlchaUI
fileprivate var limitToaster: LimitToaster?

extension BaseViewController {
    func showLimitToaster(message: String?) {
        limitToaster?.removeFromSuperview()
        limitToaster = nil
        
        let toaster = LimitToaster()
        
        container.addSubview(toaster)
        toaster.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
        }
        
        toaster.setup(title: "reset_limit".localized(.olchaNasiyaModule), content: message)
        limitToaster = toaster
    }
}
