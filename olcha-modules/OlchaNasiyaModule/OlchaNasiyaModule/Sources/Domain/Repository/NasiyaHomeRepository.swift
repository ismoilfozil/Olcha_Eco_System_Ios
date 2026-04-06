//
//  NasiyaHomeRepository.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 12/05/23.
//

import Foundation
import OlchaCore
import Combine
public protocol NasiyaHomeRepositoryProtocol {
    func loadLimit() -> AnyPublisher<BaseResponse<InstallmentLimitBalanceData, EmptyData>, Never>
    func requestLimit() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
}

public class NasiyaHomeRepository: BaseRepository, NasiyaHomeRepositoryProtocol {
    
    public func loadLimit() -> AnyPublisher<BaseResponse<InstallmentLimitBalanceData, EmptyData>, Never> {
        let api: HomeAPI = .loadLimit
        return manager.request(api: api)
    }
    
    public func requestLimit() -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never> {
        let api: HomeAPI = .requestLimit
        return manager.request(api: api)
    }
    
}

//public class NasiyaHomeMockRepository: NasiyaHomeRepositoryProtocol {
//    public func loadFAQs(page: Int) -> AnyPublisher<OlchaCore.BaseResponse<NasiyaFAQData, OlchaCore.EmptyData>, Never> {
//        return Future { promise in
//            promise(.success(
//                BaseResponse<NasiyaFAQData, EmptyData>(
//                    status: .fail,
//                    error: nil,
//                    response: nil,
//                    code: 404,
//                    errors: nil))
//            )
//        }.eraseToAnyPublisher()
//    }
//
//    public func loadNotifications(page: Int) -> AnyPublisher<BaseResponse<NasiyaNotificationData, EmptyData>, Never> {
//        return Future { promise in
//            promise(.success(
//                BaseResponse<NasiyaNotificationData, EmptyData>(
//                    status: .success,
//                    error: nil,
//                    response: NasiyaNotificationData.mock(page: page),
//                    code: 200,
//                    errors: nil))
//            )
//        }.eraseToAnyPublisher()
//    }
//}
