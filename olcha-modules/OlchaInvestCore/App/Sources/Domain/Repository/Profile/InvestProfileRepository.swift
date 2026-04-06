//
//  ProfileRepository.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 23/05/23.
//

import Foundation
import OlchaCore
import OlchaAuth
import Combine
public protocol InvestProfileRepositoryProtocol {
    func loadUser() -> AnyPublisher<BaseResponse<InvestUserData, EmptyData>, Never>
    func editUser(user: InvestUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class InvestProfileRepository: BaseRepository, InvestProfileRepositoryProtocol {
    public func loadUser() -> AnyPublisher<BaseResponse<InvestUserData, EmptyData>, Never> {
        let api: ProfileAPI = .user
        return manager.request(api: api)
    }
    
    public func editUser(user: InvestUser) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        let api: ProfileAPI = .editUser(model: user)
        return manager.request(api: api)
    }
}

//public class ProfileMockRepository: InvestProfileRepositoryProtocol {
//    public func loadUser() -> AnyPublisher<BaseResponse<NasiyaUserData, EmptyData>, Never> {
//        return Future { promise in
//
//
//            promise(.success(BaseResponse(status: .success,
//                                          error: nil,
//                                          response: NasiyaUserData.mock(),
//                                          code: 200,
//                                          errors: nil)))
//        }.eraseToAnyPublisher()
//    }
//}
