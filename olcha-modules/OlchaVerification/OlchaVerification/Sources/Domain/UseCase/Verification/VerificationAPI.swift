//
//  VerificationAPI.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 18/09/22.
//

import Foundation
import OlchaCore
import OlchaUtils

public protocol VerificationAPIProtocol {
    func passportUpload(model: PassportModel) -> BaseAPI
    func passportDownload() -> BaseAPI
    func phonesUpload(model: VerificationUploadPhonesModel) -> BaseAPI
    func phonesDownload() -> BaseAPI
    func step() -> BaseAPI
    func creditIsVerified() -> BaseAPI
}

public class VerificationAPI: VerificationAPIProtocol {
    public init() {}
    public func passportUpload(model: PassportModel) -> OlchaCore.BaseAPI {
        let api = VerificationBaseAPI(path: "installment/profile/file/upload",
                                      method: .post)
        api.body = model.image?.jpegData(compressionQuality: 0.5)
        api.params = ["type": model.type.rawValue]
        return api
    }
    
    public func passportDownload() -> BaseAPI {
        let api = VerificationBaseAPI(path: "installment/profile/step-by-step/second", method: .get)
        return api
    }
    
    public func phonesUpload(model: VerificationUploadPhonesModel) -> BaseAPI {
        let api = VerificationBaseAPI(path: "installment/profile/step-by-step/four", method: .post)
        api.body = api.encode(model)
        return api
    }
    
    public func phonesDownload() -> BaseAPI {
        let api = VerificationBaseAPI(path: "installment/profile/step-by-step/four", method: .get)
        return api
    }
    
    public func step() -> BaseAPI {
        let api = VerificationBaseAPI(
            path: "installment/profile/get-step",
            version: Texts.url.getVersion(3),
            method: .get
        )
        return api
    }
    
    public func creditIsVerified() -> OlchaCore.BaseAPI {
        let api = VerificationBaseAPI(path: "installment/profile/is-validated",
                                      version: Texts.url.getVersion(3),
                                      method: .get)
        return api
    }
    
}
