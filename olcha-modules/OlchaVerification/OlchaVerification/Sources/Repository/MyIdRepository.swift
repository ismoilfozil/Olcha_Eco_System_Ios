//
//  MyIdRepository.swift
//  OlchaVerification
//
//  Created by Ismoil Foziljonov on 01/10/25.
//

import Combine
import OlchaCore


public protocol MyIdRepositoryProtocol {
       
    
    func checkExist(model:MyIdPassportModel) -> AnyPublisher<BaseResponse<MyIdExistModel, EmptyData>, Never>
    
    func uploadMyIdCode(model:MyIdCodeModel) -> AnyPublisher<BaseResponse<EmptyData, EmptyData>, Never>
    
    
}


public class MyIdRepository : BaseRepository, MyIdRepositoryProtocol {
    
    private let api: MyIdAPIProtocol
    
    public init(manager: NetworkManagerProtocol, api: MyIdAPIProtocol) {
        self.api = api
        super.init(manager: manager)
    }
    
    
    
    public func checkExist(model: MyIdPassportModel) -> AnyPublisher<OlchaCore.BaseResponse<MyIdExistModel, OlchaCore.EmptyData>, Never> {
        manager.request(api: api.checkExist(model: model))
    }
    
    public func uploadMyIdCode(model: MyIdCodeModel) -> AnyPublisher<OlchaCore.BaseResponse<OlchaCore.EmptyData, OlchaCore.EmptyData>, Never> {
        manager.request(api: api.uploadMyIdCode(model: model))
    }
    
    
    
}
