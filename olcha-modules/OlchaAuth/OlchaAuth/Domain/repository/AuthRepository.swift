//
//  AuthRepository.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 12/04/23.
//

import Foundation
import OlchaCore
import Alamofire
import Combine
import WebKit

public protocol AuthRepositoryProtocol: AnyObject {
    var api: AuthAPIProtocol { get set }
    func getUserToken() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
    func getGuestToken() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
    func refreshAuth() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never>
    func storeUserDevice(model: UserDevice) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    func deleteUserDevice(token: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class AuthRepository: BaseRepository, AuthRepositoryProtocol {
    public var api: AuthAPIProtocol
    
    public init(api: AuthAPIProtocol, manager: NetworkManagerProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func getUserToken() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
        manager.request(api: api.userAuth(), isSingleRequest: api.isSingleRequest())
    }
    
    public func getGuestToken() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
        manager.request(api: api.guestAuth(), isSingleRequest: api.isSingleRequest())
    }
    
    public func refreshAuth() -> AnyPublisher<BaseResponse<TokenModel, EmptyData>, Never> {
        manager.request(api: api.refreshAuth(), isSingleRequest: api.isSingleRequest())
    }
    
    public func storeUserDevice(model: UserDevice) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.storeUserDevice(model: model))
    }
    
    public func deleteUserDevice(token: String) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.deleteUserDevice(fcm_token: token))
    }
}
