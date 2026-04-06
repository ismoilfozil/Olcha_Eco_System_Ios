//
//  ProfileRepository.swift
//  OlchaAuth
//
//  Created by Elbek Khasanov on 24/05/23.
//

import Foundation
import OlchaCore
import Alamofire
import Combine

public protocol ProfileRepositoryProtocol: AnyObject {
    var api: ProfileAPIProtocol { get set }
    func loadUserData() -> AnyPublisher<BaseResponse<UserData, EmptyData>, Never>
    func editUserData(model: User) -> AnyPublisher<BaseResponse<EmptyData, ValidationErrors>, Never>
    func deleteUser() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class ProfileRepository: BaseRepository, ProfileRepositoryProtocol {
    public var api: ProfileAPIProtocol
    
    public init(api: ProfileAPIProtocol, manager: NetworkManagerProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    public func loadUserData() -> AnyPublisher<BaseResponse<UserData, EmptyData>, Never> {
        manager.request(api: api.user())
    }
    
    public func editUserData(model: User) -> AnyPublisher<BaseResponse<EmptyData, ValidationErrors>, Never> {
        manager.request(api: api.editUser(model: model))
    }
 
    public func deleteUser() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        manager.request(api: api.deleteUser())
    }
    
}
