//
//  LoginRepository.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 13/04/23.
//

import Foundation
import OlchaCore
import Alamofire
import Combine

public protocol LoginRepositoryProtocol: AnyObject {
    var api: LoginAPIProtocol { get set }
    
    func checkPhone(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
    func login(model: LoginAuthModel) -> AnyPublisher<BaseResponse<LoginModel, LoginModel>, Never>
    func confirmCode(model: PhoneRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never>
    func registerPhoneCode(model: PhoneCodeProtocol) -> AnyPublisher<BaseResponse<UserAuthModel, EmptyData>, Never>
    func renewPassword(model: PasswordRenewRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
    func editPassword(model: PasswordEditRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never>
    func resetPhoneCode(model: PhoneCodeRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never>
    
}

public class LoginRepository: BaseRepository, LoginRepositoryProtocol {
    public var api: LoginAPIProtocol
    
    public init(api: LoginAPIProtocol, manager: NetworkManagerProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func checkPhone(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
        manager.request(api: api.isExist(model: phone))
    }
    
    public func login(model: LoginAuthModel) -> AnyPublisher<BaseResponse<LoginModel, LoginModel>, Never> {
        manager.request(api: api.login(model: model), isSingleRequest: api.isSingleRequest())
    }
    
    public func confirmCode(model: PhoneRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
        manager.request(api: api.confirmCode(model: model))
    }
    
    public func registerPhoneCode(model: PhoneCodeProtocol) -> AnyPublisher<BaseResponse<UserAuthModel, EmptyData>, Never> {
        manager.request(api: api.registerPhone(model: model))
    }
    
    public func renewPassword(model: PasswordRenewRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
        manager.request(api: api.renewPassword(model: model))
    }
    
    public func editPassword(model: PasswordEditRequest) -> AnyPublisher<BaseResponse<WelcomeData, ValidationErrors>, Never> {
        manager.request(api: api.editPassword(model: model))
    }
    
    public func resetPhoneCode(model: PhoneCodeRequest) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
        manager.request(api: api.resetPhone(model: model))
    }
    
    
}

//public class LoginRepository: BaseRepository, LoginRepositoryProtocol {
//    public var api: LoginAPIProtocol
//
//    public init(api: LoginAPIProtocol, manager: NetworkManagerProtocol) {
//        self.api = api
//        super.init(manager: manager)
//    }
//
//    public func checkPhone(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
//        return manager.request(api: api.isExist(model: phone))
//    }
//
//    public func login(phone: String, password: String) -> AnyPublisher<BaseResponse<LoginModel, LoginModel>, Never> {
//
//        let api: LoginAPI = .login(
//            model: .init(username: phone,
//                         password: password,
//                         client_id: AuthTexts.client_ID,
//                         client_secret: AuthTexts.client_secret,
//                         grant_type: AuthTexts.password
//                        )
//        )
//        return manager.request(api: api, isSingleRequest: true)
//    }
//
//    public func confirmCode(phone: String) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
//        let api: LoginAPI = .confirmCode(
//            model: .init(phone: phone.phoneNumber)
//        )
//
//        return manager.request(api: api)
//    }
//
//    public func registerPhoneCode(phone: String, code: String) -> AnyPublisher<BaseResponse<UserAuthModel, EmptyData>, Never> {
//        let model: PhoneCodeProtocol
//
//        if let referal = AuthGlobalDefaults.referral_id {
//            model = PhoneCodeReferalRequest(
//                phone: phone,
//                code: code,
//                referral_id: referal)
//        } else {
//            model = PhoneCodeRequest(
//                phone: phone,
//                code: code)
//        }
//
//        let api: LoginAPI = .registerPhone(model: model)
//        return manager.request(api: api)
//    }
//
//    public func renewPassword(phone: String,
//                              password: String,
//                              password2: String,
//                              code: String
//    ) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
//
//        let api: LoginAPI = .renewPassword(
//            model: .init(password: password,
//                         password_confirmation: password2,
//                         phone: phone,
//                         code: code)
//        )
//
//        return manager.request(api: api)
//    }
//
//    public func editPassword(phone: String?, password: String, password2: String) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
//        let api: LoginAPI = .editPassword(
//            model: .init(password: password,
//                         password_confirmation: password2)
//        )
//
//        return manager.request(api: api)
//    }
//
//    public func resetPhoneCode(phone: String, code: String) -> AnyPublisher<BaseResponse<WelcomeData, EmptyData>, Never> {
//        let api: LoginAPI = .resetPhone(
//            model: .init(phone: phone,
//                         code: code)
//        )
//
//        return manager.request(api: api)
//    }
//
//}
