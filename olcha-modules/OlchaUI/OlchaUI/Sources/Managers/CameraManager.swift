//
//  CameraManager.swift
//  OlchaUtils
//
//  Created by Elbek Khasanov on 21/07/23.
//

import UIKit
import AVFoundation
public class CameraManager {
    public static func checkPermission(completion: ((Bool) -> Void)? ) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion?(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isSuccess in
                if isSuccess {
                    completion?(true)
                } else {
                    completion?(false)
                    presentDeniedError()
                }
            }
            break
        default:
            completion?(false)
            presentDeniedError()
            
        }
        
    }
    
    public static func presentDeniedError() {
        DispatchQueue.main.async {
            (UIApplication.shared.main)?.showCameraError()
        }
    }
}
