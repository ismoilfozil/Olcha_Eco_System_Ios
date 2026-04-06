//
//  BiometricManager.swift
//  OlchaPayModule
//
//  Created by Elbek Khasanov on 17/02/23.
//

import Foundation
import LocalAuthentication

public class BiometricManager {
    
    public enum BiometricType {
        case none
        case touch
        case face
    }
    
    nonisolated(unsafe) public static let shared = BiometricManager()
    
    public func checkBiometric(_ completion: @escaping ((Bool) -> Void)) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            let reason = (biometricType() == .face ? "face_id_unlock" : "touch_id_unlock").localized(.resources)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isSuccess, error in
                DispatchQueue.main.async {
                    completion(isSuccess)
                }
            }
        }
        
    }
    
    public func biometricType() -> BiometricType {
        let context = LAContext()
        if #available(iOS 11, *) {
            let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(context.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            default:
                return .none
            }
        } else {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    public func checkBiometricPermission() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
