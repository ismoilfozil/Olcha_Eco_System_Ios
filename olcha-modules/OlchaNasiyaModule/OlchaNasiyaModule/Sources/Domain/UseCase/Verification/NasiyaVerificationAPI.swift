//
//  VerificationAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import Foundation
import OlchaCore
import OlchaUtils
import OlchaVerification
import UIKit

public class NasiyaVerificationAPI: VerificationAPIProtocol {
    
    public func passportUpload(model: PassportModel) -> BaseAPI {
        let api = NasiyaVerificationBaseAPI(path: "installment/profile/file/upload",
                                            version: Texts.url.getVersion(3),
                                            method: .post)
        api.body = model.image?.jpegData(compressionQuality: 0.5)
        api.params = ["type": model.type.rawValue]
        return api
    }
    
    public func passportDownload() -> BaseAPI {
        let api = NasiyaVerificationBaseAPI(path: "installment/profile/step-by-step/second",
                                            version: Texts.url.getVersion(3),
                                            method: .get)
        return api
    }
    
    public func phonesUpload(model: VerificationUploadPhonesModel) -> BaseAPI {
        let api = NasiyaVerificationBaseAPI(path: "installment/profile/step-by-step/four",
                                            version: Texts.url.getVersion(3),
                                            method: .post)
        api.body = api.encode(model)
        return api
    }
    
    public func phonesDownload() -> BaseAPI {
        let api = NasiyaVerificationBaseAPI(path: "installment/profile/step-by-step/four",
                                            version: Texts.url.getVersion(3),
                                            method: .get)
        return api
    }
    
    public func step() -> BaseAPI {
        let api = NasiyaVerificationBaseAPI(
            path: "installment/profile/get-step",
            version: Texts.url.getVersion(4),
            method: .get
        )
        return api
    }
    
    public func creditIsVerified() -> OlchaCore.BaseAPI {
        let api = NasiyaVerificationBaseAPI(path: "installment/profile/is-validated",
                                            version: Texts.url.getVersion(3),
                                            method: .get)
        return api
    }
    
}
