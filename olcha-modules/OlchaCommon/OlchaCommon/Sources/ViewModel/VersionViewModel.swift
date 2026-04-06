//
//  VersionViewModel.swift
//  OlchaCommon
//
//  Created by Elbek Khasanov on 27/06/23.
//

import UIKit
import Combine
import OlchaUtils
import OlchaUI
public class VersionViewModel: BaseViewModel {
    
    private let checkAppVersionUseCase: CheckAppVersionProtocol
    
    public init(checkAppVersionUseCase: CheckAppVersionProtocol) {
        self.checkAppVersionUseCase = checkAppVersionUseCase
    }
    
    public func checkAppVersion(isModule: Bool, version: String?, url: String) {
        guard !isModule, let version = version else { return }
        checkAppVersionUseCase.execute(version: version)
            .sink { [weak self] baseResponse in
                guard let self = self else { return }
                switch baseResponse.status {
                case .success:
                    updateAppIcon(baseResponse.response?.app_icon)
                    checkState(baseResponse.response?.getVersionState(), urlString: url)
                    break
                default:
                    break
                }
                
            }.store(in: &bag)
    }
}

private extension VersionViewModel {
    func checkState(_ state: VersionState?, urlString: String) {
        guard let state = state,
              state != .none,
              let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.keyWindow?.rootViewController?.showVersion(state: state, observer: {
            UIApplication.shared.open(url)
        })
    }
    
    func updateAppIcon(_ icon: AppIcon?) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        if icon?.rawValue != UIApplication.shared.alternateIconName {
            UIApplication.shared.setAlternateIconName(icon?.iconName)
        }
    }
}
